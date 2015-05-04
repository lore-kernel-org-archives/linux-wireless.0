Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbbEDT2V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 15:28:21 -0400
Message-ID: <1430767700.10844.24.camel@redhat.com> (sfid-20150504_212824_992300_D8E3F2C8)
Subject: Re: b43 AP does not work
From: Dan Williams <dcbw@redhat.com>
To: Nerijus =?UTF-8?Q?Bali=C5=ABnas?= <nerijus@users.sourceforge.net>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 04 May 2015 14:28:20 -0500
In-Reply-To: <loom.20150504T205530-427@post.gmane.org>
References: <loom.20150502T183011-57@post.gmane.org>
	   <5544FFE5.5090706@lwfinger.net> <loom.20150502T190504-905@post.gmane.org>
	   <loom.20150502T191744-147@post.gmane.org>
	  <1430752777.17017.2.camel@redhat.com>
	  <loom.20150504T173700-271@post.gmane.org>
	 <1430760100.10844.6.camel@redhat.com>
	 <loom.20150504T205530-427@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-05-04 at 19:00 +0000, Nerijus Baliūnas wrote:
> Dan Williams <dcbw@...> writes:
> 
> > NM actually does allow you to do that by editing the hotspot connection
> > files directly.
> 
> > If you take a look into /etc/NetworkManager/system-connections/ you
> > should see the config file, where you can edit stuff like 'channel',
> > 'ssid', 'band', 'pairwise', 'group', 'proto', etc, stuff that's familiar
> > to wpa_supplicant config too.  See 'man nm-settings' for more details on
> > all these key/value pairs.
> 
> I edited /etc/NetworkManager/system-connections/Hotspot, ran systemctl
> restart NetworkManager and ssid and password were changed. Then I added
> channel=10 to the file, restarted NM, but when I enable hotspot in Gnome,
> ssid is localhost.localdomain and password is random again. I was not able
> to have my edited ssid and password values back.

You don't actually need to restart NM, you can simply run "nmcli con
reload" to get NM to notice the changes.  I don't recall how GNOME Shell
handles the Hotspot button in its UI, but you should be able to test
independently of GNOME Shell by doing:

nmcli con up <name of hotspot connection>

Dan

