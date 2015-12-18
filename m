Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358AbbLSAof (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 19:44:35 -0500
Date: Fri, 18 Dec 2015 14:50:35 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Mario J. Rugiero" <mrugiero@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH 1/1] staging: Fix bitshifts by wrong offsets in
 wilc1000/host_interface.c
Message-ID: <20151218225035.GA26842@kroah.com> (sfid-20151219_014519_760852_F3DB2F95)
References: <1449024595-20290-1-git-send-email-mrugiero@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1449024595-20290-1-git-send-email-mrugiero@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 01, 2015 at 11:49:55PM -0300, Mario J. Rugiero wrote:
> struct set_multicast uses (implicitly) sizeof(bool) to determine how many bytes to copy in
> Handle_SetMulticastFilter. Since that is implementation defined, it triggered sparse to
> rightfully complain about shifting a bigger value than supported.
> Since it was used as if assuming it was 32 bits, I replaced the bool member by a u32.
> Also, time_out and buf_size members of ba_session_info are u16, but while copying their
> bytes into ptr in Handle_AddBASession shift 16 bits for the second byte instead of 8 bits.
> This patch fixes those two issues.
> 
> Signed-off-by: Mario J. Rugiero <mrugiero@gmail.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

How did you test this is correct?

Doesn't apply to my tree :(

thanks,

greg k-h
