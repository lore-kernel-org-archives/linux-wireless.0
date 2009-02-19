Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto053.server4you.de ([62.75.220.53]:44048 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbZBSHBD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 02:01:03 -0500
Date: Thu, 19 Feb 2009 08:01:39 +0100
From: Daniel Wagner <wagi@monom.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	networkmanager-list@gnome.org
Subject: Re: NetworkManager and mac80211_hwsim
Message-ID: <20090219070139.GA28934@toronto053.server4you.de> (sfid-20090219_080114_644752_4B965DD5)
References: <20090216160016.GA29509@toronto053.server4you.de> <1234800284.4219.136.camel@johannes.local> <20090216172528.GB29509@toronto053.server4you.de> <1234807251.1666.9.camel@localhost.localdomain> <20090218080636.GA25504@toronto053.server4you.de> <1234946159.4149.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1234946159.4149.0.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 18, 2009 at 09:35:59AM +0100, Johannes Berg wrote:
> On Wed, 2009-02-18 at 09:06 +0100, Daniel Wagner wrote:
> 
> > +	if (parent_dev != NULL) {
> > +		hal_device_property_set_string (d, "info.parent", hal_device_get_udi (parent_dev));
> > +		hal_device_property_set_string (d, "net.originating_device", hal_device_get_udi (parent_dev));
> > +	} else {
> > +		hal_device_property_set_string (d, "info.parent", "/org/freedesktop/Hal/devices/computer");
> > +		hal_device_property_set_string (d, "net.originating_device", "/org/freedesktop/Hal/devices/computer");
> > +		hal_device_property_set_string (d, "info.linux.driver", "mac80211_hwsim");
> > +		parent_dev = hal_device_store_find (hald_get_gdl (), "/org/freedesktop/Hal/devices/computer");
> > +		hal_device_property_set_string (parent_dev, "info.linux.driver", "mac80211");
> > +	}
> 
> This is actually not _that_ bad an idea, because it makes sure everybody
> else will properly link up their parent pointer in sysfs. 

That was exactly the problem. HAL creates only a 'correct' dbus tree if the
sysfs parent pointers exists. The patch just fakes the parent 'computer'.
This 'computer' node holds all parent-less nodes (eg alsa_sequencer, alsa_timer).
One further problem is that the 'computer' node doesn't have a 'info.linux.driver'
property which NM wants to read. Setting this property to 'mac80211' is
not correct for all children of this node.

> An alternative
> that doesn't guarantee that would be to check "is it in the ieee80211
> class".

At the moment NM wants a proper parent->child construct to work. Adding something like
/org/freedesktop/Hal/devices/virtual/mac80211_hwsim as parent for the child
would propably be a solution. As I said I was not really ready for fixing
this up. But if this is something worth to fix I'll do it.

daniel
