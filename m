Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43502 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab0K3Soo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 13:44:44 -0500
Subject: Re: build error with iw-0.9.21
From: Johannes Berg <johannes@sipsolutions.net>
To: "Heyendal, Carl" <CHeyendal@stanleyworks.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1D6034426110564DA0DEA9EE9793B38357E35E4103@NBE-MBX01.americas.swk.pri>
References: <1D6034426110564DA0DEA9EE9793B38357E35E4103@NBE-MBX01.americas.swk.pri>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 19:44:44 +0100
Message-ID: <1291142684.3624.24.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-11-30 at 13:26 -0500, Heyendal, Carl wrote:

> Note: I'm cross compiling for an ARM platform using CodeSourcery tools.

>  CC   iw
> /home/heyendal/projects/AM1808/platform/sdk_1_10_00_00/fs/sd_fs_working/lib/libnl.a(utils.o): In function `nl_prob2int':
> /home/heyendal/projects/AM1808/wireless/libnl-2.0/lib/utils.c:257: undefined reference to `lrint'
> collect2: ld returned 1 exit status
> make: *** [iw] Error 1

Well, looks like you should be linking against libm, but that wasn't
usually necessary to explicitly specify.

johannes

