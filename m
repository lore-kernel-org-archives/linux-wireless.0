Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:65379 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147Ab2CHCt4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 21:49:56 -0500
Date: Thu, 8 Mar 2012 03:49:52 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: NFC: Fragment LLCP I frames
Message-ID: <20120308024952.GA9008@sortiz-mobl> (sfid-20120308_035028_188421_F88657A2)
References: <20120307095142.GA24805@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120307095142.GA24805@elgon.mountain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On Wed, Mar 07, 2012 at 12:51:42PM +0300, Dan Carpenter wrote:
> Hi Samuel,
> 
> I had some questions about the patch e65b0f46edfd: "NFC: Fragment LLCP I
> frames" from Mar 5, 2012.
> 
> net/nfc/llcp/commands.c
> +       while (remaining_len > 0) {
> +
> +               frag_len = min_t(u16, local->remote_miu, remaining_len);
>                                  ^^^
> 
> This should be a cast to size_t.  Otherwise for a large value of
> remaining_len we'd loop until we hit an allocation failure with
> pdu = llcp_allocate_pdu();
Right.


> +               pdu = llcp_allocate_pdu(sock, LLCP_PDU_I,
> +                                       frag_len + LLCP_SEQUENCE_SIZE);
> +               if (pdu == NULL)
> +                       return -ENOMEM;
> +
> +               skb_put(pdu, LLCP_SEQUENCE_SIZE);
> +
> +               memcpy(skb_put(pdu, frag_len), msg_ptr, frag_len);
> +
> +               skb_queue_head(&sock->tx_queue, pdu);
> +
> +               lock_sock(sk);
> +
> +               nfc_llcp_queue_i_frames(sock);
> +
> +               release_sock(sk);
> +
> +               remaining_len -= frag_len;
> +               msg_ptr += len;
> 
> Shouldn't this be msg_ptr += frag_len?
Right as well.
I'll send an patch to John for fixing that. Do you mind me adding a:
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

to it ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
