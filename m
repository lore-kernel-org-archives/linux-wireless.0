Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38665 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab1GEHhR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 03:37:17 -0400
Received: by pzk9 with SMTP id 9so2227101pzk.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jul 2011 00:37:17 -0700 (PDT)
Date: Tue, 5 Jul 2011 10:36:15 +0300
From: Dan Carpenter <error27@gmail.com>
To: Franky Lin <frankyl@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 061/119] staging: brcm80211: further renaming in fullmac
 sources
Message-ID: <20110705073615.GO2544@shale.localdomain> (sfid-20110705_093726_827911_DEAF7E27)
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
 <1309391303-22741-62-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1309391303-22741-62-git-send-email-frankyl@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 29, 2011 at 04:47:25PM -0700, Franky Lin wrote:
> @@ -1046,7 +1038,7 @@ void brcmf_c_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
>  
>  	memcpy(arg_save, arg, strlen(arg) + 1);
>  
> -	if (strlen(arg) > BUF_SIZE) {
> +	if (strlen(arg) > PKTFILTER_BUF_SIZE) {

strlen() doesn't include the NULL terminator so probably this test
is off by one.  I didn't actually follow the code through to see
where the buffer overflow happens.  The arg_save buffer is
dynamically allocated to the correct size...  buf was the only
buffer that is PKTFILTER_BUF_SIZE and it stores a different string.

(maybe the test can just be removed?).

This whole function could be cleaned up with regards to string
handling.

For example:
	str = "pkt_filter_add";
	str_len = strlen(str);
	strncpy(buf, str, str_len);
	buf[str_len] = '\0';

could be replaced with:
	strcpy(buf, "pkt_filter_add");

>  		DHD_ERROR(("Not enough buffer %d < %d\n", (int)strlen(arg),
>  			   (int)sizeof(buf)));
>  		goto fail;

regards,
dan carpenter

