Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:61743 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaIEH16 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2014 03:27:58 -0400
Received: by mail-wi0-f171.google.com with SMTP id hi2so303923wib.4
        for <linux-wireless@vger.kernel.org>; Fri, 05 Sep 2014 00:27:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140904135654.26750.69133.stgit@potku.adurom.net>
References: <20140904135447.26750.52873.stgit@potku.adurom.net>
	<20140904135654.26750.69133.stgit@potku.adurom.net>
Date: Fri, 5 Sep 2014 09:27:57 +0200
Message-ID: <CA+BoTQmheuGLxicMCwVREkru5eh7FxV3T8qmsME4U5_2vi-iyA@mail.gmail.com> (sfid-20140905_092802_653523_988F82A3)
Subject: Re: [PATCH v3 2/2] ath10k: add testmode
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(On 4 September 2014 15:56, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Add testmode interface for starting and using UTF firmware which is used to run
> factory tests. This is implemented by adding new state ATH10K_STATE_UTF and user
> space can enable this state with ATH10K_TM_CMD_UTF_START command. To go back to
> normal mode user space can send ATH10K_TM_CMD_UTF_STOP.
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---
[...]
> +bool ath10k_tm_event_wmi(struct ath10k *ar, u32 cmd_id, struct sk_buff *skb)
> +{
> +       struct sk_buff *nl_skb;
> +       bool consumed;
> +       int ret;
> +
> +       ath10k_dbg(ar, ATH10K_DBG_TESTMODE,
> +                  "testmode event wmi cmd_id %d skb %p skb->len %d\n",
> +                  cmd_id, skb, skb->len);
> +
> +       ath10k_dbg_dump(ar, ATH10K_DBG_TESTMODE, NULL, "", skb->data, skb->len);
> +
> +       spin_lock_bh(&ar->data_lock);
> +
> +       if (!ar->testmode.utf_monitor) {
> +               consumed = false;
> +               goto out;
> +       }
> +
> +       /* Only testmode.c should be handling events from utf firmware,
> +        * otherwise all sort of problems will arise as mac80211 operations
> +        * are not initialised. */

Comment style.


> +static int ath10k_tm_cmd_utf_start(struct ath10k *ar, struct nlattr *tb[])
> +{
> +       char filename[100];
> +       int ret;
> +
> +       ath10k_dbg(ar, ATH10K_DBG_TESTMODE, "testmode cmd utf start\n");
> +
> +       mutex_lock(&ar->conf_mutex);
> +
> +       if (ar->state == ATH10K_STATE_UTF) {
> +               ret = -EALREADY;
> +               goto err;
> +       }
> +
> +       /* start utf only when the driver is not in use  */
> +       if (ar->state != ATH10K_STATE_OFF) {
> +               ret = -EBUSY;
> +               goto err;
> +       }
> +
> +       if (ar->testmode.utf != NULL)
> +               /* utf image is already downloaded */
> +               goto power_up;

I believe this shouldn't happen with the current code. We should
probably treat it with a if (WARN_ON(utf != NULL)) goto err;


> +void ath10k_testmode_destroy(struct ath10k *ar)
> +{
> +       mutex_lock(&ar->conf_mutex);
> +
> +       release_firmware(ar->testmode.utf);
> +       ar->testmode.utf = NULL;
> +
> +       if (ar->state != ATH10K_STATE_UTF) {
> +               /* utf firmware is not running, nothing to do */
> +               goto out;
> +       }
> +
> +       ath10k_core_stop(ar);

Hmm, you don't call power_down here. This isn't a problem from a
practical point of view after my recent changes but hey.

How about we split out guts from ath10k_tm_cmd_utf_stop() to
__ath10k_tm_cmd_utf_stop() (which assumes conf_mutex is already held)
and call it here like this:

 mutex_lock(conf_mutex);
 if (ar->state==UTF)
   __ath10k_tm_cmd_utf_stop(ar);
 mutex_unlock(conf_mutex);


> @@ -2488,6 +2490,17 @@ static void ath10k_wmi_10x_process_rx(struct ath10k *ar, struct sk_buff *skb)
>
>         trace_ath10k_wmi_event(ar, id, skb->data, skb->len);
>
> +       consumed = ath10k_tm_event_wmi(ar, id, skb);
> +
> +       /* Ready event must be handled normally also in UTF mode so that we
> +        * know the UTF firmware has booted, others we are just bypass WMI
> +        * events to testmode. */

Comment style.


Michał
