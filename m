Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41591 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbbGaDsX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 23:48:23 -0400
Date: Thu, 30 Jul 2015 20:48:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "tony.cho" <tony.cho@atmel.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	devel@driverdev.osuosl.org, rachel.kim@atmel.com,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, robin.hwang@atmel.com, jude.lee@atmel.com,
	leo.kim@atmel.com
Subject: Re: [PATCH V2 1/5] staging: wilc1000: #ifdef conditionals cover
 entire functions
Message-ID: <20150731034821.GA8945@kroah.com> (sfid-20150731_054826_701329_7D0057E3)
References: <1438247414-19708-1-git-send-email-tony.cho@atmel.com>
 <1438247414-19708-2-git-send-email-tony.cho@atmel.com>
 <20150730115647.GA12823@sudip-pc>
 <55BAEB08.8090705@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <55BAEB08.8090705@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2015 at 12:27:04PM +0900, tony.cho wrote:
> 
> 
> On 2015년 07월 30일 20:56, Sudip Mukherjee wrote:
> >On Thu, Jul 30, 2015 at 06:10:10PM +0900, Tony Cho wrote:
> >>This patch lets preprocessor conditionals (#ifdef) related to
> >>WILC_SDIO_IRQ_GPIO to compile out the entire functions. Compiling out
> >>the entire functions is preferred rather than portions of functions or
> >>expressions becausue doing so makes code harder to read.
> >>
> >>Signed-off-by: Tony Cho <tony.cho@atmel.com>
> >>---
> ><snip>
> >>+#ifdef WILC_SDIO_IRQ_GPIO
> >>  static int sdio_clear_int(void)
> >>  {
> >>-#ifndef WILC_SDIO_IRQ_GPIO
> >>-	/* uint32_t sts; */
> >>-	sdio_cmd52_t cmd;
> >>-
> >>-	cmd.read_write = 0;
> >>-	cmd.function = 1;
> >>-	cmd.raw = 0;
> >>-	cmd.address = 0x4;
> >>-	cmd.data = 0;
> >>-	g_sdio.sdio_cmd52(&cmd);
> >>-	int_clrd++;
> >>-
> >>-	return cmd.data;
> >>-#else
> >>  	uint32_t reg;
> >>  	if (!sdio_read_reg(WILC_HOST_RX_CTRL_0, &reg)) {
> >>@@ -181,9 +168,23 @@ static int sdio_clear_int(void)
> >>  	sdio_write_reg(WILC_HOST_RX_CTRL_0, reg);
> >>  	int_clrd++;
> >>  	return 1;
> >>-#endif
> >>+}
> >>+#else
> >>+static int sdio_clear_int(void)
> >>+{
> >>+	sdio_cmd52_t cmd;
> >>+
> >>+	cmd.read_write = 0;
> >>+	cmd.function = 1;
> >>+	cmd.raw = 0;
> >>+	cmd.address = 0x4;
> >>+	cmd.data = 0;
> >>+	g_sdio.sdio_cmd52(&cmd);
> >>+	int_clrd++;
> >>+	return cmd.data;
> >>  }
> >>+#endif /* WILC_SDIO_IRQ_GPIO */
> >instead of changing #ifndef to #ifdef i think the following would have
> >been easier:
> 
> Yes, I agree with you.

Great!

> I will rewrite them after important patches are accepted.

This is the first patch in the series, I'm not going to take it if you
are going to redo it later, please fix it correctly.

I'll drop this series from my queue.

thanks,

greg k-h
