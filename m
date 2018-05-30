Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55716 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753537AbeE3L3Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 07:29:24 -0400
Date: Wed, 30 May 2018 14:29:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thibaut Robert <thibaut.robert@gmail.com>
Cc: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: wilc1000: Use common structs to parse ip
 packets
Message-ID: <20180530112904.x4vcpkdmqhpc7xll@mwanda> (sfid-20180530_133043_373640_78C9D28E)
References: <20180529190839.12818-1-thibaut.robert@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180529190839.12818-1-thibaut.robert@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 29, 2018 at 09:08:39PM +0200, Thibaut Robert wrote:
>  static inline void tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
>  {
> -	u8 *eth_hdr_ptr;
> +	const struct ethhdr *eth_hdr_ptr = (const struct ethhdr *)tqe->buffer;
> +
>  	u8 *buffer = tqe->buffer;

No blank line, please.

> -	unsigned short h_proto;
>  	int i;
>  	unsigned long flags;
>  	struct wilc_vif *vif;
> @@ -197,37 +199,25 @@ static inline void tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
>  
>  	spin_lock_irqsave(&wilc->txq_spinlock, flags);
>  
> -	eth_hdr_ptr = &buffer[0];
> -	h_proto = ntohs(*((unsigned short *)&eth_hdr_ptr[12]));
> -	if (h_proto == ETH_P_IP) {
> -		u8 *ip_hdr_ptr;
> -		u8 protocol;
> -
> -		ip_hdr_ptr = &buffer[ETHERNET_HDR_LEN];
> -		protocol = ip_hdr_ptr[9];
> +	if (eth_hdr_ptr->h_proto == htons(ETH_P_IP)) {
> +		const struct iphdr *ip_hdr_ptr = (const struct iphdr *)
> +		  (buffer + ETH_HLEN);

If you declared buffer as a void pointer you could remove this cast.

		const struct iphdr *ip_hdr_ptr = buf + ETH_HLEN;


>  
> -		if (protocol == 0x06) {
> -			u8 *tcp_hdr_ptr;
> +		if (ip_hdr_ptr->protocol == IPPROTO_TCP) {
> +			const struct tcphdr *tcp_hdr_ptr;
>  			u32 IHL, total_length, data_offset;
>  
> -			tcp_hdr_ptr = &ip_hdr_ptr[IP_HDR_LEN];
> -			IHL = (ip_hdr_ptr[0] & 0xf) << 2;
> -			total_length = ((u32)ip_hdr_ptr[2] << 8) +
> -					(u32)ip_hdr_ptr[3];
> -			data_offset = ((u32)tcp_hdr_ptr[12] & 0xf0) >> 2;
> +			IHL = ip_hdr_ptr->ihl << 2;
> +			tcp_hdr_ptr = (const struct tcphdr *)
> +			  ((u8 *)ip_hdr_ptr + IHL);

This alignment is a bit unfortunate...  Perhaps?

			tcp_hdr_ptr = buf + ETH_HLEN + IHL;

regards,
dan carpenter
