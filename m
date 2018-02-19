Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:11928 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752798AbeBSNlb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 08:41:31 -0500
Subject: Re: [PATCH 11/12] staging: wilc1000: fix line over 80 chars in
 wilc_wlan_txq_filter_dup_tcp_ack()
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>
References: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com>
 <1518793909-15573-12-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <88343dc9-963f-f146-01c1-d983822f0157@microchip.com> (sfid-20180219_144135_135540_B75ABE2C)
Date: Mon, 19 Feb 2018 15:41:27 +0200
MIME-Version: 1.0
In-Reply-To: <1518793909-15573-12-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 16.02.2018 17:11, Ajay Singh wrote:
> Fix "line over 80 characters" issue reported by checkpatch.pl.
> Use temporary variable to avoid checkpatch.pl issue.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/wilc_wlan.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
> index 391ecd5..98cd949 100644
> --- a/drivers/staging/wilc1000/wilc_wlan.c
> +++ b/drivers/staging/wilc1000/wilc_wlan.c
> @@ -262,10 +262,20 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
>  
>  	spin_lock_irqsave(&wilc->txq_spinlock, wilc->txq_spinlock_flags);
>  	for (i = pending_base; i < (pending_base + pending_acks); i++) {
> -		if (i >= MAX_PENDING_ACKS ||
> -		    pending_acks_info[i].session_index >= 2 * MAX_TCP_SESSION)
> +		u32 session_index;
> +		u32 bigger_ack_num;
> +
> +		if (i >= MAX_PENDING_ACKS)
i >= MAX_PENDINGS_ACKS could be inserted in conditional part of for:
  	for (i = pending_base; i < (pending_base + pending_acks) &&
	     i < MAX_PENDINGS_ACKS; i++)

or:
int maxcnt = (pending_base + pending_acks > MAX_PENDINGS_ACKS) ? pending_base +
pending_ack : MAX_PENDINGS_ACKS;
for (i = pending_base; i < maxcnt; i++) {
	// ...
}

> +			break;
> +
> +		session_index = pending_acks_info[i].session_index;
> +
> +		if (session_index >= 2 * MAX_TCP_SESSION)
>  			break;
> -		if (pending_acks_info[i].ack_num < ack_session_info[pending_acks_info[i].session_index].bigger_ack_num) {
> +
> +		bigger_ack_num = ack_session_info[session_index].bigger_ack_num;
> +
> +		if (pending_acks_info[i].ack_num < bigger_ack_num) {
>  			struct txq_entry_t *tqe;
>  
>  			tqe = pending_acks_info[i].txqe;
> 
