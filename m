Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42210 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbaAFKgV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 05:36:21 -0500
Message-ID: <1389004577.5891.6.camel@jlt4.sipsolutions.net> (sfid-20140106_113624_830486_E8B5D48E)
Subject: Re: py80211 update on github
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 06 Jan 2014 11:36:17 +0100
In-Reply-To: <52CA77B5.5060100@broadcom.com> (sfid-20140106_103040_059390_26262C87)
References: <51D49027.9010803@broadcom.com> <52CA77B5.5060100@broadcom.com>
	 (sfid-20140106_103040_059390_26262C87)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-06 at 10:30 +0100, Arend van Spriel wrote:

> In the christmas holiday I tinkered a bit more on py80211. It comes with
> a utility to extract definitions and netlink policies from the nl80211
> source files. What is currently on github is in prototype state. It can
> retrieve all wiphy information including band, frequency and rate
> information. It relies on policy information and it turned out that not
> all attributes are properly initialized in nl80211_policy. One that I
> added manually is NL80211_ATTR_SUPPORTED_IFTYPES, which should actually
> be typed as NLA_NESTED. There are other attributes that are not covered yet.

This makes sense because the kernel policy only covers things that are
sent *to* the kernel. In some very rare cases, the stuff sent *to* the
kernel and *by* the kernel may even differ, so you may have to add some
special cases.

johannes

