Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:61430 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbZJTHqd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 03:46:33 -0400
Received: by ewy3 with SMTP id 3so4503476ewy.17
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2009 00:46:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2d0a357f0910200033t25c6b848x6d321057b69e47e6@mail.gmail.com>
References: <1256018933.4475.6.camel@johannes.local>
	 <2d0a357f0910200033t25c6b848x6d321057b69e47e6@mail.gmail.com>
Date: Tue, 20 Oct 2009 09:46:37 +0200
Message-ID: <2d0a357f0910200046g2a04c1d4v7a62c9e15b403999@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: sme: deauthenticate on assoc failure
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To clarify on the patchset and order:

[quilt series]:
# patches from linux-wireless ML
linux-wireless/0001-Revert-mac80211-fix-SME-warning-by-removing-stale-BS.patch
linux-wireless/mac80211-keep-auth-state-when-assoc-fails.patch
linux-wireless/cfg80211-sme-deauthenticate-on-assoc-failure.patch

- Sedat -

On Tue, Oct 20, 2009 at 9:33 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> Is this patch on top of wireless-testing (master-2009-10-16)?
>
> It fails here:
> ...
> Applying patch linux-wireless/mac80211-keep-auth-state-when-assoc-fails.patch
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
>>  net/wireless/core.h |    1 +
>>  net/wireless/mlme.c |    9 +++++++++
>>  net/wireless/sme.c  |   21 +++++++++++++++++++--
>>  3 files changed, 29 insertions(+), 2 deletions(-)
>>
>> --- wireless-testing.orig/net/wireless/core.h   2009-10-20 15:02:15.000000000 +0900
>> +++ wireless-testing/net/wireless/core.h        2009-10-20 15:03:20.000000000 +0900
>> @@ -358,6 +358,7 @@ int cfg80211_mgd_wext_connect(struct cfg
>>                              struct wireless_dev *wdev);
>>
>>  void cfg80211_conn_work(struct work_struct *work);
>> +void cfg80211_sme_failed_assoc(struct wireless_dev *wdev);
>>  bool cfg80211_sme_failed_reassoc(struct wireless_dev *wdev);
>>
>>  /* internal helpers */
>> --- wireless-testing.orig/net/wireless/mlme.c   2009-10-20 15:02:15.000000000 +0900
>> +++ wireless-testing/net/wireless/mlme.c        2009-10-20 15:03:20.000000000 +0900
>> @@ -62,6 +62,7 @@ void cfg80211_send_rx_assoc(struct net_d
>>        u8 *ie = mgmt->u.assoc_resp.variable;
>>        int i, ieoffs = offsetof(struct ieee80211_mgmt, u.assoc_resp.variable);
>>        struct cfg80211_internal_bss *bss = NULL;
>> +       bool need_connect_result = true;
>>
>>        wdev_lock(wdev);
>>
>> @@ -94,6 +95,14 @@ void cfg80211_send_rx_assoc(struct net_d
>>                }
>>
>>                WARN_ON(!bss);
>> +       } else if (wdev->conn) {
>> +               cfg80211_sme_failed_assoc(wdev);
>> +               need_connect_result = false;
>> +               /*
>> +                * do not call connect_result() now because the
>> +                * sme will schedule work that does it later.
>> +                */
>> +               goto out;
>>        }
>>
>>        if (!wdev->conn && wdev->sme_state == CFG80211_SME_IDLE) {
>> --- wireless-testing.orig/net/wireless/sme.c    2009-10-20 15:02:15.000000000 +0900
>> +++ wireless-testing/net/wireless/sme.c 2009-10-20 15:03:20.000000000 +0900
>> @@ -26,6 +26,7 @@ struct cfg80211_conn {
>>                CFG80211_CONN_AUTHENTICATING,
>>                CFG80211_CONN_ASSOCIATE_NEXT,
>>                CFG80211_CONN_ASSOCIATING,
>> +               CFG80211_CONN_DEAUTH_ASSOC_FAIL,
>>        } state;
>>        u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
>>        u8 *ie;
>> @@ -148,6 +149,12 @@ static int cfg80211_conn_do_work(struct
>>                                               NULL, 0,
>>                                               WLAN_REASON_DEAUTH_LEAVING);
>>                return err;
>> +       case CFG80211_CONN_DEAUTH_ASSOC_FAIL:
>> +               __cfg80211_mlme_deauth(rdev, wdev->netdev, params->bssid,
>> +                                      NULL, 0,
>> +                                      WLAN_REASON_DEAUTH_LEAVING);
>> +               /* return an error so that we call __cfg80211_connect_result() */
>> +               return -EINVAL;
>>        default:
>>                return 0;
>>        }
>> @@ -158,6 +165,7 @@ void cfg80211_conn_work(struct work_stru
>>        struct cfg80211_registered_device *rdev =
>>                container_of(work, struct cfg80211_registered_device, conn_work);
>>        struct wireless_dev *wdev;
>> +       u8 bssid[ETH_ALEN];
>>
>>        rtnl_lock();
>>        cfg80211_lock_rdev(rdev);
>> @@ -173,10 +181,10 @@ void cfg80211_conn_work(struct work_stru
>>                        wdev_unlock(wdev);
>>                        continue;
>>                }
>> +               memcpy(bssid, wdev->conn->params.bssid, ETH_ALEN);
>>                if (cfg80211_conn_do_work(wdev))
>>                        __cfg80211_connect_result(
>> -                                       wdev->netdev,
>> -                                       wdev->conn->params.bssid,
>> +                                       wdev->netdev, bssid,
>>                                        NULL, 0, NULL, 0,
>>                                        WLAN_STATUS_UNSPECIFIED_FAILURE,
>>                                        false, NULL);
>> @@ -337,6 +345,15 @@ bool cfg80211_sme_failed_reassoc(struct
>>        return true;
>>  }
>>
>> +void cfg80211_sme_failed_assoc(struct wireless_dev *wdev)
>> +{
>> +       struct wiphy *wiphy = wdev->wiphy;
>> +       struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
>> +
>> +       wdev->conn->state = CFG80211_CONN_DEAUTH_ASSOC_FAIL;
>> +       schedule_work(&rdev->conn_work);
>> +}
>> +
>>  void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
>>                               const u8 *req_ie, size_t req_ie_len,
>>                               const u8 *resp_ie, size_t resp_ie_len,
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
