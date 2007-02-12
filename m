Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:45799 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932845AbXBLEJO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Feb 2007 23:09:14 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HGSTt-0000bi-68
	for linux-wireless@vger.kernel.org; Sun, 11 Feb 2007 23:07:57 -0500
Subject: Re: [PATCH] d80211: Fix wireless statistics reporting
From: Pavel Roskin <proski@gnu.org>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
In-Reply-To: <200702112209.46093.flamingice@sourmilk.net>
References: <200702112209.46093.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Sun, 11 Feb 2007 23:09:10 -0500
Message-Id: <1171253350.27742.17.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Michael!

On Sun, 2007-02-11 at 22:09 -0500, Michael Wu wrote:
> d80211: Fix wireless statistics reporting
> 
> This fixes statistics reporting. It allows drivers to specify what type of
> values they support, makes scan results return correct statistics, and
> generally fixes the brain damaged statistics reporting code.
> 
> Signed-off-by: Michael Wu <flamingice@sourmilk.net>
[skip]
> -	int signal;
> +	int signal; /* used as qual in statistics reporting */

I'm sorry but that the thing I have always hated about wireless
extensions.  Such tricks make the API context sensitive and loaded with
assumptions.

> +	/* Maximum values for various statistics.
> +	 * Leave at 0 to indicate no support. Use negative numbers for dBm. */

That's another context sensitive API.

I've actually worked with the hardware capable of receiving more that 0
dBm (1mW).  It had to be worked around.  Please keep in mind that Linux
is used not only on FCC approved Part 15 devices, but also on embedded
systems operating on licensed frequencies.

"One milliwatt should be enough for everyone" is an approach flawed from
the outset.  It's limiting even for existing equipment running Linux.
One megawatt would be enough though :)

Note that Jean actually added a flag to indicate that a value is in dBm
in the latest versions of Wireless Extensions.

I understand d80211 still has to interact with Wireless Extensions, but
let's not make things even worse.

-- 
Regards,
Pavel Roskin

