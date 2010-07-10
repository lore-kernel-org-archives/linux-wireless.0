Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lager.deltatee.com ([207.54.116.66]:59948 "EHLO
	porter.deltatee.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752652Ab0GJATs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jul 2010 20:19:48 -0400
Message-ID: <4C37BCA0.5090607@deltatee.com>
Date: Fri, 09 Jul 2010 18:19:44 -0600
From: Logan Gunthorpe <logang@deltatee.com>
MIME-Version: 1.0
To: Luciano Coelho <luciano.coelho@nokia.com>
CC: linux-wireless@vger.kernel.org
In-Reply-To: 1278578525.8576.19.camel@chilepepper
Content-Type: text/plain; charset=ISO-8859-1
Subject: RE: wl1271 firmware
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Everyone,


Luciano Coelho Wrote:
> You need to get the firmware (wl1271-fw.bin) directly from TI or from
> your device manufacturer.  I don't have the permission to redistribute
> it.  The latest version that we are using is Rev. 6.1.0.0.310 (you can
> check this by running strings on and grepping the binary file).
> 
> The NVS file is another story.  It contains device-specific calibration
> values and you should probably get those from the device manufacturer.
> There is a common part (which is the INI file in tiwlan's terms), which
> you need to use to create the binary (check wl1271_ini.h for the binary
> file structure).  The more problematic part is the device-specific self
> generated calibration.  You need to run a specific sequence of commands
> in order to get these values and then apply these values to the correct
> place in the binary file.
> 
> Shahar, maybe you could contribute a tool to generate the NVS file in
> the correct format for wl1271? That would be very cool and would help
> lots of people.  Please let me know if you have interest and we can
> discuss this in more details.

I too am working with a WL1271 module and have just today got it
connected to an Atmel ARM9 development kit (AT91SAM9G45-EKES). So far it
appears to work but I have been gated by the firmware and NVS file issues.

I have a firmware binary, but it seems to be a newer version
(6.1.3.01.5) than what you are using. Does anyone have any idea if this
version will work? It seems to be the only one available on TI's
website. Additionally, our device manufacturer has been hesitant to
provide any support because we are on an unsupported platform and opted
to use the open source driver. Are there any other ways to obtain an
older version of the firmware?

The NVS file is another problem. TI's website has instructions to use a
cryptic tool that appears to come with their driver package. There is no
source for this tool and for obvious reasons would not work for us.

Anyway, I'd like to help in anyway I can. I've taken a look at the
twilan.ini file and I see the commonality with wl1271_ini.h. It would be
relatively easy to write a tool that parses the INI file and generates
the common part of the NVS file. However, I'd have no idea how to
generate the device specific calibration or the few fields missing from
the INI file.

Thanks,

Logan

P.S. I was not subscribed to this list when the message I'm replying to
was sent. I apologize if I broke the thread. I am subscribed now.

