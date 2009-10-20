Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:36191 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbZJTHlr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 03:41:47 -0400
Received: by ey-out-2122.google.com with SMTP id 9so1116676eyd.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2009 00:41:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2d0a357f0910200033t25c6b848x6d321057b69e47e6@mail.gmail.com>
References: <1256018933.4475.6.camel@johannes.local>
	 <2d0a357f0910200033t25c6b848x6d321057b69e47e6@mail.gmail.com>
Date: Tue, 20 Oct 2009 09:41:47 +0200
Message-ID: <2d0a357f0910200041m25c03477gaec88566cc871cce@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: sme: deauthenticate on assoc failure
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: multipart/mixed; boundary=0016e6d77e329c3a8b047658fe0a
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0016e6d77e329c3a8b047658fe0a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

YUPP.

- Sedat -

On Tue, Oct 20, 2009 at 9:33 AM, Sedat Dilek <sedat.dilek@googlemail.com> w=
rote:
> Is this patch on top of wireless-testing (master-2009-10-16)?
>
> It fails here:
> ...
> Applying patch linux-wireless/mac80211-keep-auth-state-when-assoc-fails.p=
atch
> patching file net/mac80211/mlme.c
> Hunk #1 FAILED at 1457.
> 1 out of 1 hunk FAILED -- rejects in file net/mac80211/mlme.c
> Patch linux-wireless/mac80211-keep-auth-state-when-assoc-fails.patch
> does not apply (enforce with -f)
> ERROR: failed to apply patch series!
>
> Does it need to revert "mac80211: fix SME warning by removing stale
> BSS upon assoc failure"?
>
> - Sedat -
>
> On Tue, Oct 20, 2009 at 8:08 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> When the in-kernel SME gets an association failure from
>> the AP we don't deauthenticate, and thus get into a very
>> confused state which will lead to warnings later on. Fix
>> this by actually deauthenticating when the AP indicates
>> an association failure.
>>
>> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>> ---
>> =C2=A0net/wireless/core.h | =C2=A0 =C2=A01 +
>> =C2=A0net/wireless/mlme.c | =C2=A0 =C2=A09 +++++++++
>> =C2=A0net/wireless/sme.c =C2=A0| =C2=A0 21 +++++++++++++++++++--
>> =C2=A03 files changed, 29 insertions(+), 2 deletions(-)
>>
>> --- wireless-testing.orig/net/wireless/core.h =C2=A0 2009-10-20 15:02:15=
.000000000 +0900
>> +++ wireless-testing/net/wireless/core.h =C2=A0 =C2=A0 =C2=A0 =C2=A02009=
-10-20 15:03:20.000000000 +0900
>> @@ -358,6 +358,7 @@ int cfg80211_mgd_wext_connect(struct cfg
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct wireless_dev *wdev);
>>
>> =C2=A0void cfg80211_conn_work(struct work_struct *work);
>> +void cfg80211_sme_failed_assoc(struct wireless_dev *wdev);
>> =C2=A0bool cfg80211_sme_failed_reassoc(struct wireless_dev *wdev);
>>
>> =C2=A0/* internal helpers */
>> --- wireless-testing.orig/net/wireless/mlme.c =C2=A0 2009-10-20 15:02:15=
.000000000 +0900
>> +++ wireless-testing/net/wireless/mlme.c =C2=A0 =C2=A0 =C2=A0 =C2=A02009=
-10-20 15:03:20.000000000 +0900
>> @@ -62,6 +62,7 @@ void cfg80211_send_rx_assoc(struct net_d
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0u8 *ie =3D mgmt->u.assoc_resp.variable;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0int i, ieoffs =3D offsetof(struct ieee80211_m=
gmt, u.assoc_resp.variable);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct cfg80211_internal_bss *bss =3D NULL;
>> + =C2=A0 =C2=A0 =C2=A0 bool need_connect_result =3D true;
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0wdev_lock(wdev);
>>
>> @@ -94,6 +95,14 @@ void cfg80211_send_rx_assoc(struct net_d
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0WARN_ON(!bss);
>> + =C2=A0 =C2=A0 =C2=A0 } else if (wdev->conn) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cfg80211_sme_failed_a=
ssoc(wdev);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 need_connect_result =
=3D false;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* do not call c=
onnect_result() now because the
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* sme will sche=
dule work that does it later.
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!wdev->conn && wdev->sme_state =3D=3D CFG=
80211_SME_IDLE) {
>> --- wireless-testing.orig/net/wireless/sme.c =C2=A0 =C2=A02009-10-20 15:=
02:15.000000000 +0900
>> +++ wireless-testing/net/wireless/sme.c 2009-10-20 15:03:20.000000000 +0=
900
>> @@ -26,6 +26,7 @@ struct cfg80211_conn {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CFG80211_CONN_AUT=
HENTICATING,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CFG80211_CONN_ASS=
OCIATE_NEXT,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CFG80211_CONN_ASS=
OCIATING,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CFG80211_CONN_DEAUTH_=
ASSOC_FAIL,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0} state;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0u8 *ie;
>> @@ -148,6 +149,12 @@ static int cfg80211_conn_do_work(struct
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 NULL, 0,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 WLAN_REASON_DEAUTH_LEAVING);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return err;
>> + =C2=A0 =C2=A0 =C2=A0 case CFG80211_CONN_DEAUTH_ASSOC_FAIL:
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __cfg80211_mlme_deaut=
h(rdev, wdev->netdev, params->bssid,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0NULL, 0,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0WLAN_REASON_D=
EAUTH_LEAVING);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* return an error so=
 that we call __cfg80211_connect_result() */
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EINVAL;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0default:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>> @@ -158,6 +165,7 @@ void cfg80211_conn_work(struct work_stru
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct cfg80211_registered_device *rdev =3D
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0container_of(work=
, struct cfg80211_registered_device, conn_work);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct wireless_dev *wdev;
>> + =C2=A0 =C2=A0 =C2=A0 u8 bssid[ETH_ALEN];
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0rtnl_lock();
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0cfg80211_lock_rdev(rdev);
>> @@ -173,10 +181,10 @@ void cfg80211_conn_work(struct work_stru
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0wdev_unlock(wdev);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0continue;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memcpy(bssid, wdev->c=
onn->params.bssid, ETH_ALEN);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (cfg80211_conn=
_do_work(wdev))
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0__cfg80211_connect_result(
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wdev->netdev=
,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wdev->conn->=
params.bssid,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wdev->netdev=
, bssid,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0NULL, =
0, NULL, 0,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0WLAN_S=
TATUS_UNSPECIFIED_FAILURE,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0false,=
 NULL);
>> @@ -337,6 +345,15 @@ bool cfg80211_sme_failed_reassoc(struct
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;
>> =C2=A0}
>>
>> +void cfg80211_sme_failed_assoc(struct wireless_dev *wdev)
>> +{
>> + =C2=A0 =C2=A0 =C2=A0 struct wiphy *wiphy =3D wdev->wiphy;
>> + =C2=A0 =C2=A0 =C2=A0 struct cfg80211_registered_device *rdev =3D wiphy=
_to_dev(wiphy);
>> +
>> + =C2=A0 =C2=A0 =C2=A0 wdev->conn->state =3D CFG80211_CONN_DEAUTH_ASSOC_=
FAIL;
>> + =C2=A0 =C2=A0 =C2=A0 schedule_work(&rdev->conn_work);
>> +}
>> +
>> =C2=A0void __cfg80211_connect_result(struct net_device *dev, const u8 *b=
ssid,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const u8 *req_ie, size_t req_ie_len,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const u8 *resp_ie, size_t resp_ie_len,
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.html
>>
>

--0016e6d77e329c3a8b047658fe0a
Content-Type: text/x-diff; charset=US-ASCII;
	name="0001-Revert-mac80211-fix-SME-warning-by-removing-stale-BS.patch"
Content-Disposition: attachment;
	filename="0001-Revert-mac80211-fix-SME-warning-by-removing-stale-BS.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g10cjru40

RnJvbSBmMTNhMTljMTg2NTM1NWNiNjJhZTczMDUzOGM5NzllY2YwNjUzYzJhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBUdWUsIDIwIE9jdCAyMDA5IDA5OjM5OjM2ICswMjAwClN1YmplY3Q6IFtQQVRDSF0gUmV2
ZXJ0ICJtYWM4MDIxMTogZml4IFNNRSB3YXJuaW5nIGJ5IHJlbW92aW5nIHN0YWxlIEJTUyB1cG9u
IGFzc29jIGZhaWx1cmUiCgpUaGlzIHJldmVydHMgY29tbWl0IDczOTg0ZDk2NjBhNTY5MzM2ODU0
NjU3ZmI0YWRhZTM4YzE2NzMxNzcuCi0tLQogbmV0L21hYzgwMjExL21sbWUuYyB8ICAgIDIgKy0K
IDEgZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL25ldC9tYWM4MDIxMS9tbG1lLmMgYi9uZXQvbWFjODAyMTEvbWxtZS5jCmluZGV4IDY5
N2ExNDkuLjcxMjIwYTUgMTAwNjQ0Ci0tLSBhL25ldC9tYWM4MDIxMS9tbG1lLmMKKysrIGIvbmV0
L21hYzgwMjExL21sbWUuYwpAQCAtMTQ2NSw3ICsxNDY1LDcgQEAgaWVlZTgwMjExX3J4X21nbXRf
YXNzb2NfcmVzcChzdHJ1Y3QgaWVlZTgwMjExX3N1Yl9pZl9kYXRhICpzZGF0YSwKIAkJICAgICAg
IHNkYXRhLT5kZXYtPm5hbWUsIHN0YXR1c19jb2RlKTsKIAkJbGlzdF9kZWwoJndrLT5saXN0KTsK
IAkJa2ZyZWUod2spOwotCQlyZXR1cm4gUlhfTUdNVF9DRkc4MDIxMV9ERUFVVEg7CisJCXJldHVy
biBSWF9NR01UX0NGRzgwMjExX0FTU09DOwogCX0KIAogCWlmICgoYWlkICYgKEJJVCgxNSkgfCBC
SVQoMTQpKSkgIT0gKEJJVCgxNSkgfCBCSVQoMTQpKSkKLS0gCjEuNi4zLjEKCg==
--0016e6d77e329c3a8b047658fe0a--
