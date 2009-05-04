Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:54359 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752863AbZEDIHJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 04:07:09 -0400
Date: Mon, 4 May 2009 11:06:58 +0300
From: Jouni Malinen <j@w1.fi>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] add support for parsing WPA and RSN/WPA2 information
	elements
Message-ID: <20090504080658.GA3141@jm.kir.nu>
References: <1241412381-2778-1-git-send-email-marcel@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1241412381-2778-1-git-send-email-marcel@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 03, 2009 at 09:46:21PM -0700, Marcel Holtmann wrote:

> +static void print_auth(const unsigned char *oui, unsigned char *data)
> +{
> +	if (memcmp(data, oui, 3) == 0) {
> +		switch (data[3]) {
> +		case 0x01:
> +			printf("802.1x");

s/802.1x/IEEE 802.1X/

> +			break;
> +		case 0x02:
> +			printf("PSK");
> +			break;

If you want more coverage here, IEEE 802.11r-2008 adds 00-0F-AC:3 (FT
authentication negotiated over IEEE 802.1X) and 00-0F-AC:4 (FT
authentication using PSK). Please note that these are defined only for
OUI 00-0F-AC, though.

In addition, IEEE 802.11w will be adding 00-0F-AC:5 (IEEE 802.1X or
PMKSA caching with SHA256 Key Derivation) and 00-0F-AC-6 (PSK with
SHA256 Key Derivation).

> +static void print_wpa(const char *ie, const unsigned char *oui,
> +		      unsigned char len, unsigned char *data)
> +{

> +	if (len < 4) {
> +		tab_on_first(&first);
> +		printf("\t * Group cipher: TKIP\n");
> +		printf("\t * Pairwise ciphers: TKIP\n");

These default are correct for WPA IE, but not for RSN IE/WPA2. However,
it looks like this function is used for both and as such, the WPA2 case
should print out CCMP here (and same below if only the pairwise cipher
suite field is omitted).

In addition, this could show the default AKM value (IEEE 802.1X) if it
is not included in the IE.
 
-- 
Jouni Malinen                                            PGP id EFC895FA
