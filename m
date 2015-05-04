Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbbEDRVt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 13:21:49 -0400
Message-ID: <1430760100.10844.6.camel@redhat.com> (sfid-20150504_192152_371851_C576C97C)
Subject: Re: b43 AP does not work
From: Dan Williams <dcbw@redhat.com>
To: Nerijus =?UTF-8?Q?Bali=C5=ABnas?= <nerijus@users.sourceforge.net>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 04 May 2015 12:21:40 -0500
In-Reply-To: <loom.20150504T173700-271@post.gmane.org>
References: <loom.20150502T183011-57@post.gmane.org>
	  <5544FFE5.5090706@lwfinger.net> <loom.20150502T190504-905@post.gmane.org>
	  <loom.20150502T191744-147@post.gmane.org>
	 <1430752777.17017.2.camel@redhat.com>
	 <loom.20150504T173700-271@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-05-04 at 15:41 +0000, Nerijus Baliūnas wrote:
> Dan Williams <dcbw@...> writes:
> 
> > > Just FYI - "access point" mode of the NM applet works (in Gnome). But it
> > > would still be nice to have hostapd working.
> > 
> > If you want to use hostapd on the card and the system is running
> > NetworkManager, you can tell NM to ignore the device through the
> > "unmanaged-devices" option in NetworkManager.conf.  manpages have more
> > details.
> 
> But I don't want NM to ignore the device - I use the wifi card with NM
> as a client. But sometimes I'd like to use hostapd directly (as NM
> does not allow me to configure AP parameters - channel, wpa number,
> AP name and password). It was possible before, but not any more.

NM actually does allow you to do that by editing the hotspot connection
files directly.  The various UIs (nm-applet, GNOME Shell, etc) may or
may not expose specific knobs like these.  We intend to add AP mode
support to nm-connection-editor, but there are some complications around
valid options in AP mode that need to be addressed in the editor UI
first.

If you take a look into /etc/NetworkManager/system-connections/ you
should see the config file, where you can edit stuff like 'channel',
'ssid', 'band', 'pairwise', 'group', 'proto', etc, stuff that's familiar
to wpa_supplicant config too.  See 'man nm-settings' for more details on
all these key/value pairs.

Dan


