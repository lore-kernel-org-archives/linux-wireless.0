Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:54997 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaBNGsA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Feb 2014 01:48:00 -0500
Received: by mail-bk0-f45.google.com with SMTP id mz13so107103bkb.18
        for <linux-wireless@vger.kernel.org>; Thu, 13 Feb 2014 22:47:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392318594-32540-1-git-send-email-greearb@candelatech.com>
References: <1392318594-32540-1-git-send-email-greearb@candelatech.com>
Date: Fri, 14 Feb 2014 07:47:58 +0100
Message-ID: <CA+BoTQmDCrmkB3FErCN-XDX6M_Vzk3BuAK3AXcNK00qePje7XA@mail.gmail.com> (sfid-20140214_074806_346791_46DDFE8D)
Subject: Re: [RFC] wmi: Handle failure to start scan.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 February 2014 20:09,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> Properly clean up driver state in case firmware fails
> to start scan for some reason.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath10k/wmi.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index 20f7c79..a5be0d3 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -770,7 +770,25 @@ static int ath10k_wmi_event_scan(struct ath10k *ar, struct sk_buff *skb)
>                 ath10k_dbg(ATH10K_DBG_WMI, "WMI_SCAN_EVENT_PREEMPTED\n");
>                 break;
>         case WMI_SCAN_EVENT_START_FAILED:
> -               ath10k_dbg(ATH10K_DBG_WMI, "WMI_SCAN_EVENT_START_FAILED\n");
> +               ath10k_warn("WMI_SCAN_EVENT_START_FAILED, reason: %i\n", reason);
> +
> +               ar->scan_channel = NULL;
> +               if (!ar->scan.in_progress) {
> +                       ath10k_warn("scan-start-failed: no scan requested, ignoring\n");
> +                       break;
> +               }
> +
> +               if (ar->scan.is_roc) {
> +                       ath10k_offchan_tx_purge(ar);
> +
> +                       if (!ar->scan.aborting)
> +                               ieee80211_remain_on_channel_expired(ar->hw);
> +               } else {
> +                       ieee80211_scan_completed(ar->hw, ar->scan.aborting);
> +               }
> +
> +               del_timer(&ar->scan.timeout);
> +               ar->scan.in_progress = false;
>                 break;
>         default:
>                 break;

We already wait for EVENT_STARTED in mac.c (see ath10k_start_scan) and
clean up stuff (ath10k_abort_scan). Why not add the missing bits in
there? Or is it possible to get EVENT_START_FAILED *after*
EVENT_STARTED? Or am I missing something else here?


Michał
