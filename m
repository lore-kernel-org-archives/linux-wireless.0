Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:37974 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab2JOPtR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 11:49:17 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so1206537eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 15 Oct 2012 08:49:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121012121333.GA30816@redhat.com>
References: <CAJZjf_wv=+HKLwnH-=rvx9h=0jEGzoCrd-a8GOW-QnXfOVgc_g@mail.gmail.com>
 <20120807102208.GA12589@redhat.com> <CAJZjf_xVOKjVYYXxsWf6Z+KaTDi_3ZDqvBMyzMETfbkpWUgWFQ@mail.gmail.com>
 <CAJZjf_xVzQmpLHd=KQ0qc77QxdpE0a7xjGTNo2Sw6BM8miwe7A@mail.gmail.com>
 <20121003143029.GF2259@redhat.com> <CAJZjf_xZC2473B2SQAKFfc7m6SSeEK7z7N-GaUsZUNV-K9c=Ww@mail.gmail.com>
 <20121012121333.GA30816@redhat.com>
From: Pedro Francisco <pedrogfrancisco@gmail.com>
Date: Mon, 15 Oct 2012 16:48:55 +0100
Message-ID: <CAJZjf_zeyeTXvxgHrCHJqRD_HpziWcsgDcnNq3K9+ieDQB28hA@mail.gmail.com> (sfid-20121015_174920_916147_B2D19B9C)
Subject: Re: unloading WiFi modules is usually triggering kernel crash
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: ML linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: multipart/mixed; boundary=047d7b6704cdcaf6a304cc1afa65
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--047d7b6704cdcaf6a304cc1afa65
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Oct 12, 2012 at 1:13 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Tue, Oct 09, 2012 at 10:14:40AM +0100, Pedro Francisco wrote:
>> So, I'm guessing this means it is related to what you found on iwlwifi
>> (even if I'm on iwlegacy)?
>
> Yes, this seems to be cfg80211 problem. I think crash happen because
> cfg80211 is in disassociate state (i.e. has wdev->current_bss NULL) and
> erroneously mac80211 stays in associate state. So while we unload
> module cfg80211_mlme_down() we do not call ieee80211_deauth().
>
> I think this state mishmash happens because wrong behaviour on
>  __cfg80211_mlme_deauth(). Below patch try to correct that.
> Can you check if it prevent a crash? On my environment I can
> not reproduce this problem reliably.
>
> Thanks
> Stanislaw
>
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index ab78b53..9b99b60 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1218,6 +1218,7 @@ struct cfg80211_deauth_request {
>         const u8 *ie;
>         size_t ie_len;
>         u16 reason_code;
> +       bool local_state_change;
>  };
>
>  /**
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index e714ed8..e510a33 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -3549,6 +3549,7 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
>  {
>         struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
>         u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
> +       bool tx = !req->local_state_change;
>
>         mutex_lock(&ifmgd->mtx);
>
> @@ -3565,12 +3566,12 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
>         if (ifmgd->associated &&
>             ether_addr_equal(ifmgd->associated->bssid, req->bssid)) {
>                 ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
> -                                      req->reason_code, true, frame_buf);
> +                                      req->reason_code, tx, frame_buf);
>         } else {
>                 drv_mgd_prepare_tx(sdata->local, sdata);
>                 ieee80211_send_deauth_disassoc(sdata, req->bssid,
>                                                IEEE80211_STYPE_DEAUTH,
> -                                              req->reason_code, true,
> +                                              req->reason_code, tx,
>                                                frame_buf);
>         }
>
> diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
> index 3df195a..4954010 100644
> --- a/net/wireless/mlme.c
> +++ b/net/wireless/mlme.c
> @@ -457,21 +457,11 @@ int __cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
>                 .reason_code = reason,
>                 .ie = ie,
>                 .ie_len = ie_len,
> +               .local_state_change = local_state_change,
>         };
>
>         ASSERT_WDEV_LOCK(wdev);
>
> -       if (local_state_change) {
> -               if (wdev->current_bss &&
> -                   ether_addr_equal(wdev->current_bss->pub.bssid, bssid)) {
> -                       cfg80211_unhold_bss(wdev->current_bss);
> -                       cfg80211_put_bss(&wdev->current_bss->pub);
> -                       wdev->current_bss = NULL;
> -               }
> -
> -               return 0;
> -       }
> -
>         return rdev->ops->deauth(&rdev->wiphy, dev, &req);
>  }
>

I've been testing the patch since this morning (GMT), I can't
reproduce any of the issues I referred on this thread (had to adapt
the patch slightly, though). Seems to be fixed!

Thank you for your help!
-- 
Pedro Francisco

--047d7b6704cdcaf6a304cc1afa65
Content-Type: application/octet-stream;
	name="mlme-timers-fedora-3.6.1-fc17-kernel.patch"
Content-Disposition: attachment;
	filename="mlme-timers-fedora-3.6.1-fc17-kernel.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h8beflxp1

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L2NmZzgwMjExLmggYi9pbmNsdWRlL25ldC9jZmc4MDIx
MS5oCmluZGV4IDNkMjU0ZTEuLmYxMDU1M2MgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbmV0L2NmZzgw
MjExLmgKKysrIGIvaW5jbHVkZS9uZXQvY2ZnODAyMTEuaApAQCAtMTIxNyw2ICsxMjE3LDcgQEAg
c3RydWN0IGNmZzgwMjExX2RlYXV0aF9yZXF1ZXN0IHsKIAljb25zdCB1OCAqaWU7CiAJc2l6ZV90
IGllX2xlbjsKIAl1MTYgcmVhc29uX2NvZGU7CisJYm9vbCBsb2NhbF9zdGF0ZV9jaGFuZ2U7CiB9
OwogCiAvKioKZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS9tbG1lLmMgYi9uZXQvbWFjODAyMTEv
bWxtZS5jCmluZGV4IGY3NmI4MzMuLmRhM2Y1ZTQgMTAwNjQ0Ci0tLSBhL25ldC9tYWM4MDIxMS9t
bG1lLmMKKysrIGIvbmV0L21hYzgwMjExL21sbWUuYwpAQCAtMzQ1Nyw2ICszNDU3LDcgQEAgaW50
IGllZWU4MDIxMV9tZ2RfZGVhdXRoKHN0cnVjdCBpZWVlODAyMTFfc3ViX2lmX2RhdGEgKnNkYXRh
LAogewogCXN0cnVjdCBpZWVlODAyMTFfaWZfbWFuYWdlZCAqaWZtZ2QgPSAmc2RhdGEtPnUubWdk
OwogCXU4IGZyYW1lX2J1ZltERUFVVEhfRElTQVNTT0NfTEVOXTsKKwlib29sIHR4ID0gIXJlcS0+
bG9jYWxfc3RhdGVfY2hhbmdlOwogCiAJbXV0ZXhfbG9jaygmaWZtZ2QtPm10eCk7CiAKQEAgLTM0
NzMsMTEgKzM0NzQsMTEgQEAgaW50IGllZWU4MDIxMV9tZ2RfZGVhdXRoKHN0cnVjdCBpZWVlODAy
MTFfc3ViX2lmX2RhdGEgKnNkYXRhLAogCWlmIChpZm1nZC0+YXNzb2NpYXRlZCAmJgogCSAgICBl
dGhlcl9hZGRyX2VxdWFsKGlmbWdkLT5hc3NvY2lhdGVkLT5ic3NpZCwgcmVxLT5ic3NpZCkpCiAJ
CWllZWU4MDIxMV9zZXRfZGlzYXNzb2Moc2RhdGEsIElFRUU4MDIxMV9TVFlQRV9ERUFVVEgsCi0J
CQkJICAgICAgIHJlcS0+cmVhc29uX2NvZGUsIHRydWUsIGZyYW1lX2J1Zik7CisJCQkJICAgICAg
IHJlcS0+cmVhc29uX2NvZGUsIHR4LCBmcmFtZV9idWYpOwogCWVsc2UKIAkJaWVlZTgwMjExX3Nl
bmRfZGVhdXRoX2Rpc2Fzc29jKHNkYXRhLCByZXEtPmJzc2lkLAogCQkJCQkgICAgICAgSUVFRTgw
MjExX1NUWVBFX0RFQVVUSCwKLQkJCQkJICAgICAgIHJlcS0+cmVhc29uX2NvZGUsIHRydWUsCisJ
CQkJCSAgICAgICByZXEtPnJlYXNvbl9jb2RlLCB0eCwKIAkJCQkJICAgICAgIGZyYW1lX2J1Zik7
CiAJbXV0ZXhfdW5sb2NrKCZpZm1nZC0+bXR4KTsKIApkaWZmIC0tZ2l0IGEvbmV0L3dpcmVsZXNz
L21sbWUuYyBiL25ldC93aXJlbGVzcy9tbG1lLmMKaW5kZXggMWNkYjFkNS4uMDg3N2VmYiAxMDA2
NDQKLS0tIGEvbmV0L3dpcmVsZXNzL21sbWUuYworKysgYi9uZXQvd2lyZWxlc3MvbWxtZS5jCkBA
IC00NTcsMjEgKzQ1NywxMSBAQCBpbnQgX19jZmc4MDIxMV9tbG1lX2RlYXV0aChzdHJ1Y3QgY2Zn
ODAyMTFfcmVnaXN0ZXJlZF9kZXZpY2UgKnJkZXYsCiAJCS5yZWFzb25fY29kZSA9IHJlYXNvbiwK
IAkJLmllID0gaWUsCiAJCS5pZV9sZW4gPSBpZV9sZW4sCisJCS5sb2NhbF9zdGF0ZV9jaGFuZ2Ug
PSBsb2NhbF9zdGF0ZV9jaGFuZ2UsCiAJfTsKIAogCUFTU0VSVF9XREVWX0xPQ0sod2Rldik7CiAK
LQlpZiAobG9jYWxfc3RhdGVfY2hhbmdlKSB7Ci0JCWlmICh3ZGV2LT5jdXJyZW50X2JzcyAmJgot
CQkgICAgZXRoZXJfYWRkcl9lcXVhbCh3ZGV2LT5jdXJyZW50X2Jzcy0+cHViLmJzc2lkLCBic3Np
ZCkpIHsKLQkJCWNmZzgwMjExX3VuaG9sZF9ic3Mod2Rldi0+Y3VycmVudF9ic3MpOwotCQkJY2Zn
ODAyMTFfcHV0X2Jzcygmd2Rldi0+Y3VycmVudF9ic3MtPnB1Yik7Ci0JCQl3ZGV2LT5jdXJyZW50
X2JzcyA9IE5VTEw7Ci0JCX0KLQotCQlyZXR1cm4gMDsKLQl9Ci0KIAlyZXR1cm4gcmRldi0+b3Bz
LT5kZWF1dGgoJnJkZXYtPndpcGh5LCBkZXYsICZyZXEpOwogfQogCg==
--047d7b6704cdcaf6a304cc1afa65--
