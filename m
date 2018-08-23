Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:35548 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729393AbeHWLkN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 07:40:13 -0400
Subject: Re: [PATCH 19/24] staging: wilc1000: avoid line over 80 chars in
 wilc_wlan_txq_filter_dup_tcp_ack()
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
 <1534229416-13254-20-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <fedc9184-964a-f051-c490-0fdd821cc580@microchip.com> (sfid-20180823_101333_276965_02FEB44F)
Date: Thu, 23 Aug 2018 11:11:28 +0300
MIME-Version: 1.0
In-Reply-To: <1534229416-13254-20-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 14.08.2018 09:50, Ajay Singh wrote:
> Cleanup patch to avoid line over 80 chars checkpatch issue introduced in
> previous code refactor commit.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/wilc_wlan.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
> index 52402c3..041c9dd 100644
> --- a/drivers/staging/wilc1000/wilc_wlan.c
> +++ b/drivers/staging/wilc1000/wilc_wlan.c
> @@ -199,19 +199,20 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&wilc->txq_spinlock, flags);
> -	for (i = f->pending_base; i < (f->pending_base + f->pending_acks); i++) {
> -		u32 session_index;
> +	i = f->pending_base;
You could do it like this to avoid line over 80 chars checkpatch.pl warnings:

	for (i = f->pending_base;
	     i < (f->pending_base + f->pending_acks); i++) {

> +	for (; i < (f->pending_base + f->pending_acks); i++) {
> +		u32 index;
>  		u32 bigger_ack_num;
>  
>  		if (i >= MAX_PENDING_ACKS)
>  			break;
>  
> -		session_index = f->pending_acks_info[i].session_index;
> +		index = f->pending_acks_info[i].session_index;
>  
> -		if (session_index >= 2 * MAX_TCP_SESSION)
> +		if (index >= 2 * MAX_TCP_SESSION)
>  			break;
>  
> -		bigger_ack_num = f->ack_session_info[session_index].bigger_ack_num;
> +		bigger_ack_num = f->ack_session_info[index].bigger_ack_num;
>  
>  		if (f->pending_acks_info[i].ack_num < bigger_ack_num) {
>  			struct txq_entry_t *tqe;
> 
