Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:23260 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaIVJql (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2014 05:46:41 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 6/9] ath10k: deduplicate wmi service ready logic
References: <1411046487-19544-1-git-send-email-michal.kazior@tieto.com>
	<1411046487-19544-7-git-send-email-michal.kazior@tieto.com>
	<87a95wngzt.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQmsVqvGgu_fUqKGqhEKXV7E_w0KdcH_GFoPhAvyjtVdDA@mail.gmail.com>
Date: Mon, 22 Sep 2014 12:46:35 +0300
In-Reply-To: <CA+BoTQmsVqvGgu_fUqKGqhEKXV7E_w0KdcH_GFoPhAvyjtVdDA@mail.gmail.com>
	(Michal Kazior's message of "Fri, 19 Sep 2014 10:43:25 +0200")
Message-ID: <87oau8m1hg.fsf@kamboji.qca.qualcomm.com> (sfid-20140922_114647_931103_E41EFE9E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 19 September 2014 10:37, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> +     if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
>>> +             ret = ath10k_wmi_10x_pull_svc_rdy_ev(skb, &arg);
>>> +             wmi_10x_svc_map(arg.service_map, svc_bmap);
>>> +     } else {
>>> +             ret = ath10k_wmi_pull_svc_rdy_ev(skb, &arg);
>>> +             wmi_main_svc_map(arg.service_map, svc_bmap);
>>> +     }
>>
>> For consistency shouldn't the latter be
>> ath10k_wmi_main_pull_svc_rdy_ev()?
>
> Good point. Makes sense. I'll add the _main to the function name.
>
>
>>> --- a/drivers/net/wireless/ath/ath10k/wmi.h
>>> +++ b/drivers/net/wireless/ath/ath10k/wmi.h
>>> @@ -1394,6 +1394,7 @@ struct wlan_host_mem_req {
>>>   * wmi_service_ready_event,e.g., 11ac pass some of the
>>>   * device capability to the host.
>>>   */
>>> +
>>>  struct wmi_service_ready_event {
>>>       __le32 sw_version;
>>>       __le32 sw_version_1;
>>
>> Isn't this unneeded change?
>
> Good catch. I'll fix that.

Like discussed in IRC, you don't need to resent the whole patchset just
because of this. I have now folded the patch below onto your patch in
ath-next-test, please review:

https://github.com/kvalo/ath/commit/1d13ab4a3bdfd342ed8fbead859de398b379435c

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 37a520150358..a7c11b292bf4 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2205,8 +2205,8 @@ static int ath10k_wmi_alloc_host_mem(struct ath10k *ar, u32 req_id,
 	return 0;
 }
 
-static int ath10k_wmi_pull_svc_rdy_ev(struct sk_buff *skb,
-				      struct wmi_svc_rdy_ev_arg *arg)
+static int ath10k_wmi_main_pull_svc_rdy_ev(struct sk_buff *skb,
+					   struct wmi_svc_rdy_ev_arg *arg)
 {
 	struct wmi_service_ready_event *ev;
 	size_t i, n;
@@ -2286,7 +2286,7 @@ static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
 		ret = ath10k_wmi_10x_pull_svc_rdy_ev(skb, &arg);
 		wmi_10x_svc_map(arg.service_map, svc_bmap);
 	} else {
-		ret = ath10k_wmi_pull_svc_rdy_ev(skb, &arg);
+		ret = ath10k_wmi_main_pull_svc_rdy_ev(skb, &arg);
 		wmi_main_svc_map(arg.service_map, svc_bmap);
 	}
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index ebdf15454f27..ca31cdbac557 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1394,7 +1394,6 @@ struct wlan_host_mem_req {
  * wmi_service_ready_event,e.g., 11ac pass some of the
  * device capability to the host.
  */
-
 struct wmi_service_ready_event {
 	__le32 sw_version;
 	__le32 sw_version_1;


-- 
Kalle Valo
