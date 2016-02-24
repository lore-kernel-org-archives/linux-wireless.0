Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:34335 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675AbcBXIk1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 03:40:27 -0500
Received: by mail-wm0-f43.google.com with SMTP id b205so24672307wmb.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 00:40:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <bed91e066a4998603c33ebcfaf507ccd2fabab5e.1456256461.git.poh@qca.qualcomm.com>
References: <bed91e066a4998603c33ebcfaf507ccd2fabab5e.1456256461.git.poh@qca.qualcomm.com>
Date: Wed, 24 Feb 2016 09:40:25 +0100
Message-ID: <CA+BoTQ=GhHdbkiy9sNVM+BgFcrnsgNb_RxO+c8b_tpgacVYzWg@mail.gmail.com> (sfid-20160224_094031_802133_953ACF3A)
Subject: Re: [PATCH v2] ath10k: set MAC timestamp in management Rx frame
From: Michal Kazior <michal.kazior@tieto.com>
To: Peter Oh <poh@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 February 2016 at 20:44, Peter Oh <poh@qca.qualcomm.com> wrote:
> From: poh <poh@qca.qualcomm.com>
>
> Check and set Rx MAC timestamp when firmware indicates it.
> Firmware adds it in Rx beacon frame only at this moment.
> Driver and mac80211 may utilize it to detect such clockdrift
> or beacon collision and use the result for beacon collision
> avoidance.
>
> Signed-off-by: poh <poh@qca.qualcomm.com>

Your from/s-o-b doesn't seem right - just "poh"? Shouldn't it say
"Peter Oh" instead? :)



> ---
>
> v2:
>         - fix kbuild test robot warning, left shift count >= width of type,
>         at __le32_to_cpu(arg.ext_info.rx_mac_timestamp_u32) << 32
>
>  drivers/net/wireless/ath/ath10k/wmi.c | 14 ++++++++++++++
>  drivers/net/wireless/ath/ath10k/wmi.h |  8 ++++++++
>  2 files changed, 22 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index 0f01a8d..b2a4cda 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -2167,6 +2167,7 @@ static int ath10k_wmi_op_pull_mgmt_rx_ev(struct ath10k *ar, struct sk_buff *skb,
>         struct wmi_mgmt_rx_event_v1 *ev_v1;
>         struct wmi_mgmt_rx_event_v2 *ev_v2;
>         struct wmi_mgmt_rx_hdr_v1 *ev_hdr;
> +       struct wmi_mgmt_rx_ext_info *ext_info;
>         size_t pull_len;
>         u32 msdu_len;
>
> @@ -2195,6 +2196,12 @@ static int ath10k_wmi_op_pull_mgmt_rx_ev(struct ath10k *ar, struct sk_buff *skb,
>         if (skb->len < msdu_len)
>                 return -EPROTO;
>
> +       if (arg->status & WMI_RX_STATUS_EXT_INFO) {
> +               ext_info = (struct wmi_mgmt_rx_ext_info *)
> +                          (skb->data + arg->buf_len);

I would expect the ext_info structure to be aligned at 4 byte
boundaries (or is it?) but buf_len isn't guaranteed to be multiple of
4. This could mean you grab garbage in some cases depending on the
mgmt frame size (i.e. whether its size is multiple of 4). It might be
coincidence it works for you?


Michał
