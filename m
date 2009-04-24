Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:42082 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761379AbZDXRzc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2009 13:55:32 -0400
Message-ID: <49F1FD4B.2020909@oracle.com> (sfid-20090424_195552_965106_45F236D6)
Date: Fri, 24 Apr 2009 10:56:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for April 24 (p54 build error)
References: <20090424150456.ff35e4ea.sfr@canb.auug.org.au>
In-Reply-To: <20090424150456.ff35e4ea.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


drivers/net/wireless/p54/p54.h:193: error: array type has incomplete element type

struct p54_led_dev definition is controlled by
#ifdef CONFIG_P54_LEDS (is not set)

but the struct declaration is controlled by
#ifdef CONFIG_MAC80211_LEDS (=y)


-- 
~Randy
