Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:47250 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbYKXCms (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Nov 2008 21:42:48 -0500
Received: by ey-out-2122.google.com with SMTP id 6so737735eyi.37
        for <linux-wireless@vger.kernel.org>; Sun, 23 Nov 2008 18:42:46 -0800 (PST)
Message-ID: <492A14A7.4040808@gmail.com> (sfid-20081124_034253_862151_4D9A6DE9)
Date: Sun, 23 Nov 2008 21:42:47 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
Subject: [Fwd: please don't regress ath5k.h]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sorry for sending twice, accidentally sent to owner instead of list...

wireless-testing.git/drivers/net/wireless/ath5k/ath5k.h

/* TODO: Clean up channel debuging -doesn't work anyway- and start
* working on reg. control code using all available eeprom information
* -rev. engineering needed- */
#define CHAN_DEBUG      0


I recently saw this additional comment added to wireless-testing.git and 
it has me a bit concerned.  I use this feature for a specific patch set 
that I maintain and it would break it pretty bad to remove this.  I 
don't believe I need all of the features that chan_debug provides, but 
when I set chan_debug to 0 it severely limits the number of channels 
that I can set the driver to.  I currently maintain a patch that 
supports 471 channels for atheros a/b/g cards and without chan_debug 1 
it simply cuts the top channels off (because it isn't able to have that 
many channels).  It is my opinion that the driver should support what 
the hardware supports and the regulatory requirements should be handled 
by crda as expected, I will submit some patches to this effect asap but 
in the mean time please do not remove chan_debug without enabling 
support for at least 471 channels to be stored (and it would be cool to 
cc me on that patch so I can follow it and make sure it works for me).

Thanks,
Rick Farina

PS> Please note, this is not meant to start a discussion about adding in 
addition channels that may or may not be legal, I promise I'll start 
that discussion next, but this mail is to request that a feature I'm not 
using not be removed from the driver breaking my work.  Thanks.


