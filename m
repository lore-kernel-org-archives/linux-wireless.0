Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:46217 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852AbZC0UCr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 16:02:47 -0400
Received: by ewy9 with SMTP id 9so1211855ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 27 Mar 2009 13:02:44 -0700 (PDT)
Message-ID: <49CD30D8.9070403@gmail.com> (sfid-20090327_210251_319730_8B2A8AE0)
Date: Fri, 27 Mar 2009 16:02:32 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: iw error message enhancement request
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was just trying to support a user in the irc channel with the 
following error:

14:14 < ~incastrix-hl>  Zero_Chaos: receive a strange message after: iw 
phy phy0 interface add wlan11 type ap
14:14 < ~incastrix-hl>  Zero_Chaos:  http://wireless.kernel.org/RTFM-AP


In case you read that like I did, you read it wrong, let me explain better:

Kid src # iw phy phy0 interface add wlan12 type ap
See http://wireless.kernel.org/RTFM-AP.

Yes, you read that right, when you try to use iw to create a master/ap 
mode interface it gives NO ERROR, NO EXPLAINATION, and refers you to a 
web page (which doesn't even mention this error mind you).  This doesn't 
make any sense at all.  There are two rational solutions:

1.) Use a meaningful error message such as "Hostapd is required for 
master mode: please see http://wireless.kernel.org/RTFM-AP"

2.) Remove the option to make a master mode interface from iw 
completely.  Since iw doesn't have the ability to set master mode this 
is a completely pointless option.  It's like adding an option to ping 
like "ping -irssi freeenode.net" which outputs "See http://www.irssi.org".

I favor option 1 because iw is the obvious place where people will be 
looking to set master mode so having a useful error message there is 
needed in my opinion.  The likelyhood for someone to try and set master 
mode from iw IMHO negates the arguement I make in option 2, but I wanted 
to present both logical options.

Either way, what is in iw right now is aweful.  Not only does it not 
explain what is going on with that error message, but the website 
doesn't even mention the problem.  Additionally, presuming that someone 
has internet when they are running iw isn't a safe assumption at all.  
Maybe I have no internet and I want to bring up an AP to play a LAN game 
with friends? Or any number of other reasons to bring up an AP without 
internet.  Please folks, this is just sloppy.

-Rick Farina
