Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4110 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbYLaX1M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2008 18:27:12 -0500
Date: Wed, 31 Dec 2008 18:26:09 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	htl10@users.sourceforge.net,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-wireless@vger.kernel.org,
	linux-pm@lists.linux-foundation.org,
	USB list <linux-usb@vger.kernel.org>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: [linux-pm] rtl8187 usb wifi adaptor causes suspend hang
Message-ID: <20081231232609.GA27391@hash.localnet> (sfid-20090101_002719_259256_09275B8C)
References: <348894.23448.qm@web23108.mail.ird.yahoo.com> <495B82CB.6050205@tuffmail.co.uk> <495BC8F9.4040203@lwfinger.net> <495BF975.7030603@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <495BF975.7030603@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 31, 2008 at 05:00:05PM -0600, Larry Finger wrote:
> +#ifdef CONFIG_PM
> +
> +static int rtl8187_suspend(struct usb_interface *intf, pm_message_t
> state)
> +{
> +	struct ieee80211_hw *dev = usb_get_intfdata(intf);
> +
> +	rtl8187_stop(dev);
> +
> +	return 0;
> +}

Won't this do the wrong thing if the interface is never brought up
before you do suspend?  (And then you can add a flag etc. to handle
that case, but that's exactly what my mac80211 patches aim to do.)

-- 
Bob Copeland %% www.bobcopeland.com

