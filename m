Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087AbaLLSwp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 13:52:45 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Krzysztof Konopko <kris@konagma.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: Fix sparse warnings
References: <1418336609-10191-1-git-send-email-kris@konagma.com>
	<548A2E7A.4010303@lwfinger.net> <548AD2F1.3080200@konagma.com>
	<548B2752.7030607@lwfinger.net>
Date: Fri, 12 Dec 2014 13:52:35 -0500
In-Reply-To: <548B2752.7030607@lwfinger.net> (Larry Finger's message of "Fri,
	12 Dec 2014 11:35:14 -0600")
Message-ID: <wrfjwq5wwvik.fsf@redhat.com> (sfid-20141212_195305_262660_09FCC8AD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:
> On 12/12/2014 05:35 AM, Krzysztof Konopko wrote:
>> I was hunting particularly for inconsistencies with `sparse` and came
>> across this one.  But I dug a bit further and I wonder why the driver is
>> not using standard stuff like the one in `include/linux/ieee80211.h`
>> where any data wider than one byte is clearly declared as __le<nn>?
>
> That is a good question. One possibility is that those definitions do
> not exist on some of the older kernels that Realtek supports. They
> generally work with 2.6.18 and newer.

The reason the 8723au driver doesn't use the defines from there is that
in ieee80211.h they are part of struct ieee80211_mgmt, while the 8723au
driver access the addba etc. elements without the full struct in place.

Jes
