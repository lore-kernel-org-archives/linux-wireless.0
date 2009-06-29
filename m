Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:40147 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758231AbZF2MJv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2009 08:09:51 -0400
Subject: Re: Using a Debian box as an AP with wireless testing and hostapd
From: Pavel Roskin <proski@gnu.org>
To: javier.galvez@entel.upc.edu
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <145d4e1a0906290200v4a45d83esf8eab021f6d094f9@mail.gmail.com>
References: <145d4e1a0906290158y4710d68ej270907f297335d42@mail.gmail.com>
	 <145d4e1a0906290200v4a45d83esf8eab021f6d094f9@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 29 Jun 2009 08:09:52 -0400
Message-Id: <1246277392.21239.6.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-06-29 at 11:00 +0200, Javier Gálvez Guerrero wrote:
> Hi all,
> 
> I'm trying to use my Debian box as an AP using the latest wireless
> testing kernel (2.6.30-wl) and a WiFi card Asus WL-138G v2 PCI but I'm
> experiencing a weird problem, hope you can guide me through it.
> 
> First, I'll tell what and how I setup it. I downloaded the wireless
> testing kernel and installed it (make && make modules && make
> modules_install && make install), prepared the boot images and updated
> the grub; fine. Next I installed compat-wireless, wireless regdb,
> crda, libnl, hostapd and iw following this tutorial
> (http://acx100.erley.org/git.html), with slight modifications: install
> some missing packages (m2crypto, libgcrypt-dev and libssl-dev) and,
> after installing compat-wireless, 'make unload' as suggested by the
> 'make install' output.

You don't need compat-wireless with 2.6.30-wl.  The whole point of
compat-wireless is to backport the latest drivers from the "-wl" kernel
to older kernels.

Please remove /lib/modules/2.6.30-wl and reinstall the kernel by running
"make modules_install install".

-- 
Regards,
Pavel Roskin
