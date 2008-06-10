Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108]:12780
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753904AbYFJAXH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 20:23:07 -0400
Subject: Re: Is configfs the right solution for configuration based fs?
From: Ben Nizette <bn@niasdigital.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux kernel <linux-kernel@vger.kernel.org>,
	Greg KH <greg@kroah.com>, Joel Becker <joel.becker@oracle.com>,
	Satyam Sharma <ssatyam@cse.iitk.ac.in>,
	Felix Fietkau <nbd@openwrt.org>,
	Al Viro <viro@ftp.linux.org.uk>,
	"H. Peter Anvin" <hpa@kernel.org>
In-Reply-To: <1213002187.698.62.camel@johannes.berg>
References: <43e72e890806081425h4e785800nc618fc1985f9809f@mail.gmail.com>
	 (sfid-20080608_232543_873639_74C0A387)  <1213002187.698.62.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 10 Jun 2008 10:12:52 +1000
Message-Id: <1213056772.4089.42.camel@moss.renham> (sfid-20080610_022312_320845_6AD50B94)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2008-06-09 at 11:03 +0200, Johannes Berg wrote:

> Personally, I have a few issues with this:
>  1) why bother with a second configuration interface that we have to
>     maintain, adjust, ...? if we need scriptable access, then make a
>     good userspace tool that is scriptable.

What's the first one, sysfs..?  ioctl (eww..)?  I do think they solve
different problems, both have their place.  IMHO sysfs is forced to do
configuration in some situations where it just doesn't fit.  Prolly 'coz
sysfs have the easy __DEVICE_ATTR kinda macros where as configfs takes
more effort to get flying.

>  2) string-based stuff is often messy, especially the varying attributes
>     like MAC addresses etc. Unless we just use binary files again, which
>     is not very useful again. Take, for example, the monitor flags. If
>     we use the same flags then nobody really knows what's up 
>     (echo 0x3 > mntr_flags?) and if we use strings then we cannot easily
>     ever rename the flag while keeping ABI/API compatibility.

Not sure I see the argument here, why would you want to change the flag
name?  If you decide the old name is stupid then can't you just alias
the old name to the new one?

String handling is always a bit iffy, though it has to be done
somewhere, either in kernel or in your "good userspace tool which is
scriptable".  I'd prefer to have it done once, well, in the kernel and
not have to ship more software than necessary.

>  3) afaik configfs doesn't actually support the mkdir, ... stuff yet
>     that you want for virtual interfaces.

It has all the  mkdir stuff I can think of, can you elaborate?  It
doesn't have the commitable object support but I just have an 'enabled'
attribute in there to switch the thing on and off.

My main problem with configfs (and I've done a few things with it) is
the complexity of the thing, particularly config_group vs config_item vs
config_attribute.  I'd quite like to see just config_group representing
"directory" type objects and attributes representing, well, attributes
in the dir.

That and a bit of wider use would probably see configfs growing helper
macros like those which make sysfs attributes a piece of cake to
implement.

And the trival problem that, ISTR, failing the make_group method always
reports -ENOMEM to userspace, no matter what the actual problem was.  I
think I had a patch around to pass the error code from make_group back
up through to userspace, I wonder what happened to that...

	--Ben.
