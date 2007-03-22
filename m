Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:29882 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965645AbXCVD4v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2007 23:56:51 -0400
Subject: Re: [PATCH 3/5] mac80211: fix key restricted/open display
From: Hong Liu <hong.liu@intel.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Jouni Malinen <j@w1.fi>, Michael Wu <flamingice@sourmilk.net>,
	Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1174260946.8053.20.camel@localhost.localdomain>
References: <1174015698.3408.41.camel@devlinux-hong>
	 <200703161328.41006.flamingice@sourmilk.net>
	 <1174103177.3026.8.camel@localhost.localdomain>
	 <20070318164506.GB5358@jm.kir.nu>
	 <1174260946.8053.20.camel@localhost.localdomain>
Content-Type: text/plain
Message-Id: <1174535025.9000.25.camel@devlinux-hong>
Mime-Version: 1.0
Date: Thu, 22 Mar 2007 11:43:45 +0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-03-19 at 07:35, Dan Williams wrote:
> On Sun, 2007-03-18 at 09:45 -0700, Jouni Malinen wrote:
> > WE-18 introduced IW_AUTH_80211_AUTH_ALG and that should be used if user
> > space wants to explicitly select which 802.11 authentication algorithm
> > is to be used. Please let the IW_ENCODE_OPEN/RESTRICTED misuse die.
> 
> Obviously we want it to die.  But the better solution is to make apps
> that care about "exclude unencrypted", which there are few, use
> ENCODEEXT and keep OPEN/RESTRICTED be what most of the old drivers
> expect it to be; the selector for OS/SK.  Then clean up all the double
> meanings with cfg80211 and call it day.
> 
> Dan

As far as mac80211 is concerned, I think the patch is not needed.
mac80211 has done what it needed to do through the SIOC{S/G}IWAUTH
interface.
It seems the fix should be in userspace app, iwconfig should use the
SIOC{S/G}IWAUTH interface and resort to IW_ENCODE_RESTRICTED if it wants
to maintain the compatibility with old drivers.

Thanks,
Hong
