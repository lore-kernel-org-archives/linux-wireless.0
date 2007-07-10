Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:63925 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705AbXGJRBW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2007 13:01:22 -0400
Date: Tue, 10 Jul 2007 10:00:39 -0700
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2.6] WE : Fix get 32 char ESSID
Message-ID: <20070710170039.GA6171@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <20070709221322.GA1381@bougret.hpl.hp.com> <20070710151044.GC7927@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070710151044.GC7927@tuxdriver.com>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 10, 2007 at 11:10:44AM -0400, John W. Linville wrote:
> On Mon, Jul 09, 2007 at 03:13:22PM -0700, Jean Tourrilhes wrote:
> 
> > 	A little bug was introduced a few months ago that prevent
> > reading ESSID with 32 character. Philippe Teuwen was the first one to
> > report that, followed by the MadWifi team :
> > 		http://madwifi.org/ticket/930
> > 	The patch fix this bug by removing obsolete code. It also
> > reenable setting the full range of ESSID, including ESSID with a final
> > NUL which are valid. This was tested on 2.6.21 and 2.6.22.
> > 	John : would you mind pushing that to 2.6.23 ? If you are
> > happy with it, I can provide backport patches for earlier kernels.
> 
> Jean,
> 
> Thanks for the patch.
> 
> Iirc, I wrote this ugly little piece of code that you seek to remove.

	Yes, I remember perfectly the context of that piece of code,
and I was assuming you did ;-) It was last autumn, and we said it was
temporary. As we have now found that it's buggy, it's a good time to
remove it.

> It's purpose is/was to preserve userland ABI for older versions of
> the wireless-tools package.  I'll have to dig a little deeper if you
> need a more detailed refresher -- let me know.

	If you want, I can fully refresh you ;-)

> In that case, I believe the issue was that using older wireless-tools
> w/ newer kernels would result in the SSID getting truncated by one
> character.  If we apply this patch (removing my hack/fix), won't we
> be reintroducing that issue?  If not, can you remind me as to why not?

	Yes, we would definitely reintroduce the issue with older
versions of Wireless Tools. But, as this API has been deprecated for
now more than one year (february 2006), and as this patch causes
troubles, it is time to get rid of it.
	These are the released distributions that have a "good"
version of Wireless Tools and wpa_supplicant :
		Debian 4.0 Etch
		Unbuntu 6.10 Edgy and 7.04 Feisty
		Fedora 6.93 and 7.0
		OpenSuSE 10.2
		Mandriva 2007.0 and 2007.1
		Slackware 11.0 and 12.0
	As you can see, most distro have now 2 releases which are
"good"...

> Thanks,
> 
> John

	Regards,

	Jean
