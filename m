Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:9254 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbaAFJac (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 04:30:32 -0500
Received: from [10.176.68.141] (unknown [10.176.68.141])	by
 mail-sj1-12.sj.broadcom.com (Postfix) with ESMTP id 262C3207C0	for
 <linux-wireless@vger.kernel.org>; Mon,  6 Jan 2014 01:30:30 -0800 (PST)
Message-ID: <52CA77B5.5060100@broadcom.com> (sfid-20140106_103040_059390_26262C87)
Date: Mon, 6 Jan 2014 10:30:29 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: py80211 update on github
References: <51D49027.9010803@broadcom.com>
In-Reply-To: <51D49027.9010803@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/03/2013 10:57 PM, Arend van Spriel wrote:
> A common say in Linux arena is "when you have an itch, just scratch it".
> My itch is that tools like ifconfig and iw are great, but in an
> automated test environment it kind of sucks to parse output, which is
> confirmed by blurb from iw: "Do NOT screenscrape this tool, we don't
> consider its output stable.".

In the christmas holiday I tinkered a bit more on py80211. It comes with
a utility to extract definitions and netlink policies from the nl80211
source files. What is currently on github is in prototype state. It can
retrieve all wiphy information including band, frequency and rate
information. It relies on policy information and it turned out that not
all attributes are properly initialized in nl80211_policy. One that I
added manually is NL80211_ATTR_SUPPORTED_IFTYPES, which should actually
be typed as NLA_NESTED. There are other attributes that are not covered yet.

> 
> https://github.com/arend/py80211
> 

The source files are found in the github repository. It has two
branches. The master branch is based on 3.12.6 and I intend to follow
the kernel releases on that. The wl-next branch is based on the
wireless-next repository.

Regards,
Arend
