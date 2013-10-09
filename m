Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36777 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab3JIIcK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Oct 2013 04:32:10 -0400
Message-ID: <1381307517.14186.5.camel@jlt4.sipsolutions.net> (sfid-20131009_103214_837901_59220706)
Subject: Re: [PATCH] cfg80211: Pass station supported channel and oper class
 info to kernel
From: Johannes Berg <johannes@sipsolutions.net>
To: "Undekari, Sunil Dutt" <c_duttus@qti.qualcomm.com>
Cc: "j@w1.fi.com" <j@w1.fi>, linux-wireless@vger.kernel.org
Date: Wed, 09 Oct 2013 10:31:57 +0200
In-Reply-To: <26F3B0343EE4744AA14EEEF9E1E534511F725129@aphydexd01a>
References: <1381150309-27293-1-git-send-email-c_duttus@qti.qualcomm.com>
	 <1381222569.13359.3.camel@jlt4.sipsolutions.net>
	 <26F3B0343EE4744AA14EEEF9E1E534511F725129@aphydexd01a>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-10-09 at 08:19 +0000, Undekari, Sunil Dutt wrote:
> Hi Johannes,
> 
> >I guess then wpa_supplicant would have to remove the info - maybe the failure case shouldn't be quite as draconic? Maybe make it ignore any extra trailing byte?
> Thanks for your point. 
> I suppose, returning a failure for the length being less than 2 even after ignoring the trailing byte is not required for the reason that the supported channels is not a mandatory field (at least w.r.t TDLS). It should be fine to just pass the length as 0 to the host driver. Please correct me.

It's just a question of where to address this - in the kernel or the
supplicant. In a way, I'd rather have the kernel reject it and do the
policy of ignoring invalid stuff in the supplicant.

johannes

