Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39200 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757660Ab3FEWnx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 18:43:53 -0400
Date: Wed, 5 Jun 2013 15:43:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 01/13] staging: vt6656: cleanup MACvWriteMultiAddr
Message-ID: <20130605224352.GA19437@kroah.com> (sfid-20130606_004356_484298_227F7DCC)
References: <1370463202.6213.16.camel@canaries64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1370463202.6213.16.camel@canaries64>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 05, 2013 at 09:13:22PM +0100, Malcolm Priestley wrote:
> Remove internal white space and camel case.
> 
> Camel case changes;
> pDevice -> priv
> uByteidx -> byte_idx
> byData -> data
> 
> Functional change secondary buffer byData1 removed.
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>  drivers/staging/vt6656/mac.c | 24 +++++++++---------------
>  drivers/staging/vt6656/mac.h |  2 +-
>  2 files changed, 10 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
> index 343db19..89d700f 100644
> --- a/drivers/staging/vt6656/mac.c
> +++ b/drivers/staging/vt6656/mac.c
> @@ -46,26 +46,20 @@ static int          msglevel                =MSG_LEVEL_INFO;
>   *      Write MAC Multicast Address Mask
>   *
>   * Parameters:
> - *  In:
> - *      uByteidx    - Index of Mask
> - *      byData      - Mask Value to write
> - *  Out:
> - *      none
> + * In:
> + *	byte_idx - Index of Mask
> + *	data- Mask Value to write
> + * Out:
> + *	none
>   *
>   * Return Value: none
>   *
>   */
> -void MACvWriteMultiAddr(struct vnt_private *pDevice, u32 uByteIdx, u8 byData)
> +void MACvWriteMultiAddr(struct vnt_private *priv, u16 byte_idx, u8 data)

Why did you change the variable type of byte_idx?  You don't document
that in your changelog above.

Yes, it's being cast, but don't mix formatting / variable name changes
with logical changes please.  Remember, one patch per "thing" you
change.

please redo this.

thanks,

greg k-h
