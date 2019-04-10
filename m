Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C00DFC282DA
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 03:55:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 874222133D
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 03:55:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (4096-bit key) header.d=d-silva.org header.i=@d-silva.org header.b="F/gHDQID"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfDJDzp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 23:55:45 -0400
Received: from ushosting.nmnhosting.com ([167.160.173.127]:49232 "EHLO
        ushosting.nmnhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbfDJDzp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 23:55:45 -0400
X-Greylist: delayed 1348 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Apr 2019 23:55:44 EDT
Received: from mail2.nmnhosting.com (unknown [202.169.106.97])
        by ushosting.nmnhosting.com (Postfix) with ESMTPS id 67B932F28FBB;
        Tue,  9 Apr 2019 23:33:15 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=d-silva.org;
        s=201810a; t=1554867195;
        bh=nRxc2X9u5eYN5qosM3Fxas/OX7b4OdSe8dRjwyMZHtQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=F/gHDQIDK8lLwbRkufrayf3fcwi0pcYnj9JDTiH+U7SbZ6vxcbb7LQ5n2m7LRgC2a
         fYGlsEV4dpYtorV0TddpZP/T50Xvh/XzqzYysOLqywKCfpFID+JuXJFj4hB6nJj99A
         a9Kl8juQbXbw1BPb8oB+TZcqpCuWMPiJyJ6cnWl8nNlSCTG8rYQlBc9K/dICXPT+HS
         sGl2fJny4zHFoNh7ubP2Ma/43roAr8HfvgYaBYEoTG7Ku1xdN8vr/uUU4rjPehxtji
         f97R3QkVOj3Hdl/N4XQvORMjx3fWDMIE2jUbGGhlSmwAr2QpRtwZmGBtojBsNWOWZu
         tD7gD+yLXY1XJfXbxhi/RJpKMe5XkffxnQHlyeu4glPNms4+SMZuFT5XcY0e02idKy
         nvmNIqVq08K6v1iDd3inVtyrYypgVN3TPCiKBeLpMfx7FfnRCKFmMcQp5AXb/pqhG+
         RWqtZ3U3wD0lnEjkKtaHkJt4oiFzuyAsG8dSRdINnj3eCFizbrwnudAodUOgSfN0RH
         TcLjEdSL2+fCVjk0PGrJ9IZ+enh3s/dqUboOOOukZgLbC0mVtVk2nyr8MN6y1aKZa3
         xANfWg0lJ5c3dLEolOJSv/HpyiGcvVQ342b0jl3kz8nM5vHRejoJNnfl0mbS3en/Zq
         n8V8Dh58tDXhoTe2y6TFTIrM=
Received: from adsilva.ozlabs.ibm.com (static-82-10.transact.net.au [122.99.82.10] (may be forged))
        (authenticated bits=0)
        by mail2.nmnhosting.com (8.15.2/8.15.2) with ESMTPSA id x3A3Wl7t094875
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 10 Apr 2019 13:33:02 +1000 (AEST)
        (envelope-from alastair@d-silva.org)
Message-ID: <646b3b03b2c9a2612d3bbc6f1e00d4f9fa79769f.camel@d-silva.org>
Subject: Re: [PATCH 2/4] lib/hexdump.c: Optionally suppress lines of filler
 bytes
From:   "Alastair D'Silva" <alastair@d-silva.org>
To:     Jani Nikula <jani.nikula@linux.intel.com>
Cc:     Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Karsten Keil <isdn@linux-pingi.de>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Benson Leung <bleung@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fsdevel@vger.kernel.org
Date:   Wed, 10 Apr 2019 13:32:46 +1000
In-Reply-To: <20190410031720.11067-3-alastair@au1.ibm.com>
References: <20190410031720.11067-1-alastair@au1.ibm.com>
         <20190410031720.11067-3-alastair@au1.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail2.nmnhosting.com [10.0.1.20]); Wed, 10 Apr 2019 13:33:10 +1000 (AEST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-04-10 at 13:17 +1000, Alastair D'Silva wrote:
> From: Alastair D'Silva <alastair@d-silva.org>
> 
> Some buffers may only be partially filled with useful data, while the
> rest
> is padded (typically with 0x00 or 0xff).
> 
This patch introduces flags which allow lines of padding bytes to be
> suppressed, making the output easier to interpret:
> HEXDUMP_SUPPRESS_0X00,
> HEXDUMP_SUPPRESS_0XFF
> 
> The first and last lines are not suppressed by default, so the
> function
> always outputs something. This behaviour can be further controlled
> with
> the HEXDUMP_SUPPRESS_FIRST & HEXDUMP_SUPPRESS_LAST flags.
> 
> An inline wrapper function is provided for backwards compatibility
> with
> existing code, which maintains the original behaviour.
> 
> Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
> ---
> 
<snip>

> diff --git a/lib/hexdump.c b/lib/hexdump.c
> index b8a164814744..2f3bafb55a44 100644
> --- a/lib/hexdump.c
> +++ b/lib/hexdump.c
> @@ -209,8 +209,21 @@ int hex_dump_to_buffer(const void *buf, size_t
> len, int rowsize, int groupsize,
>  EXPORT_SYMBOL(hex_dump_to_buffer);
>  
>  #ifdef CONFIG_PRINTK
> +
> +static bool buf_is_all(const u8 *buf, size_t len, u8 val)
> +{
> +	size_t i;
> +
> +	for (i = 0; i < len; i++) {
> +		if (buf[i] != val)
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
>  /**
> - * print_hex_dump - print a text hex dump to syslog for a binary
> blob of data
> + * print_hex_dump_ext: dump a binary blob of data to syslog in
> hexadecimal
>   * @level: kernel log level (e.g. KERN_DEBUG)
>   * @prefix_str: string to prefix each line with;
>   *  caller supplies trailing spaces for alignment if desired
> @@ -221,42 +234,73 @@ EXPORT_SYMBOL(hex_dump_to_buffer);
>   * @buf: data blob to dump
>   * @len: number of bytes in the @buf
>   * @ascii: include ASCII after the hex output
This line should have been removed. I'll address it in V2.

> + * @flags: A bitwise OR of the following flags:
> + *	HEXDUMP_ASCII:		include ASCII after the hex output
> + *	HEXDUMP_SUPPRESS_0X00:	suppress lines that are all 0x00
> + *				(other than first or last)
> + *	HEXDUMP_SUPPRESS_0XFF:	suppress lines that are all 0xff
> + *				(other than first or last)
> + *	HEXDUMP_SUPPRESS_FIRST:	allows the first line to be
> suppressed
> + *	HEXDUMP_SUPPRESS_LAST:	allows the last line to be suppressed
> + *				If the first and last line may be
> suppressed,
> + *				an empty buffer will not produce any
> output
>   *
>   * Given a buffer of u8 data, print_hex_dump() prints a hex + ASCII
> dump
>   * to the kernel log at the specified kernel log level, with an
> optional
>   * leading prefix.
>   *
> - * print_hex_dump() works on one "line" of output at a time, i.e.,
> + * print_hex_dump_ext() works on one "line" of output at a time,
> i.e.,
>   * 16, 32 or 64 bytes of input data converted to hex + ASCII output.
> - * print_hex_dump() iterates over the entire input @buf, breaking it
> into
> + * print_hex_dump_ext() iterates over the entire input @buf,
> breaking it into
>   * "line size" chunks to format and print.
>   *
>   * E.g.:
> - *   print_hex_dump(KERN_DEBUG, "raw data: ", DUMP_PREFIX_ADDRESS,
> - *		    16, 1, frame->data, frame->len, true);
> + *   print_hex_dump_ext(KERN_DEBUG, "raw data: ",
> DUMP_PREFIX_ADDRESS,
> + *		    16, 1, frame->data, frame->len, HEXDUMP_ASCII);
>   *
>   * Example output using %DUMP_PREFIX_OFFSET and 1-byte mode:
>   * 0009ab42: 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e
> 4f  @ABCDEFGHIJKLMNO
>   * Example output using %DUMP_PREFIX_ADDRESS and 4-byte mode:
>   * ffffffff88089af0: 73727170 77767574 7b7a7978
> 7f7e7d7c  pqrstuvwxyz{|}~.
>   */

-- 
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva    
Twitter: @EvilDeece
blog: http://alastair.d-silva.org


