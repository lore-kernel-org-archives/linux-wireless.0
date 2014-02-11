Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0007.hostedemail.com ([216.40.44.7]:36937 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751970AbaBKBjH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 20:39:07 -0500
Message-ID: <1392082740.2507.49.camel@joe-AO722> (sfid-20140211_023912_558559_13C55042)
Subject: Re: [PATCH v2] ieee80211: Print human-readable disassoc/deauth
 reason codes
From: Joe Perches <joe@perches.com>
To: Calvin Owens <jcalvinowens@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 10 Feb 2014 17:39:00 -0800
In-Reply-To: <20140211012523.GA2739@gmail.com>
References: <1391651088-31785-1-git-send-email-jcalvinowens@gmail.com>
	 <1391661863.30094.56.camel@joe-AO722>
	 <1392030546.4128.11.camel@jlt4.sipsolutions.net>
	 <1392050359.2507.10.camel@joe-AO722> <20140211012523.GA2739@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-02-10 at 19:25 -0600, Calvin Owens wrote:
> Create a function to return a descriptive string for each reason code,
> and print that instead of the numeric value in the kernel log. These
> codes are easily found on popular search engines, but one is generally
> not able to access the internet when dealing with wireless connectivity
> issues.
> 
> Changes since v1: Refactored array of strings into switch statement,
> print numeric code in addition to string.

trivia:

> +const char *ieee80211_get_reason_code_string(u16 reason_code)
> +{
> +	enum ieee80211_reasoncode r = reason_code;

what good does this temporary do?

> +	switch(r) {

space after switch please.

> +	case WLAN_REASON_UNSPECIFIED: return "UNSPECIFIED";
> +	case WLAN_REASON_PREV_AUTH_NOT_VALID: return "PREV_AUTH_NOT_VALID";
> +	case WLAN_REASON_DEAUTH_LEAVING: return "DEAUTH_LEAVING";

This seems a bit too wall of text to me.

Maybe a simplifying macro like:

#define case_WLAN(type)				\
	case WLAN_REASON_##type: return #type

and use:
	switch (reason_code) {
	case_WLAN(UNSPECIFIED);
	case_WLAN(PREV_AUTH_NOT_VALID);

etc...


