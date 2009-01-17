Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:55234 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763376AbZAQQU7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Jan 2009 11:20:59 -0500
Received: from c213-89-104-149.bredband.comhem.se ([213.89.104.149]:60047 helo=[192.168.0.142])
	by ch-smtp02.sth.basefarm.net with esmtp (Exim 4.68)
	(envelope-from <tsr.offentlig@tsr.se>)
	id 1LODur-00075R-8O
	for linux-wireless@vger.kernel.org; Sat, 17 Jan 2009 17:20:58 +0100
Message-ID: <49720566.8080202@tsr.se> (sfid-20090117_172108_328050_2BF29002)
Date: Sat, 17 Jan 2009 17:20:54 +0100
From: tsr <tsr.offentlig@tsr.se>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: Marvell 88w8385 Support
References: <496C8468.4060101@tsr.se>  <20090113145213.GA3623@tuxdriver.com>	 <1231951654.14909.22.camel@localhost.localdomain>	 <496E1D6A.10505@gmail.com>  <496E3075.6090901@tsr.se>	 <1231959472.14909.73.camel@localhost.localdomain> <1232127390.22915.9.camel@174-147-64-233.pools.spcsdns.net>
In-Reply-To: <1232127390.22915.9.camel@174-147-64-233.pools.spcsdns.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> On Wed, 2009-01-14 at 13:57 -0500, Dan Williams wrote:
>> On Wed, 2009-01-14 at 19:35 +0100, tsr wrote:
>>> John Daiker wrote:
>>>> On 01/14/2009 08:47 AM, Dan Williams wrote:
>>>>> On Tue, 2009-01-13 at 09:52 -0500, John W. Linville wrote:
>>>>>   
>>>>>> On Tue, Jan 13, 2009 at 01:09:12PM +0100, tsr wrote:
>>>>>>     
>>>>>>> Hi,
>>>>>>>
>>>>>>> I have a FSG-3 that includes a Marvell 88w8385 card. I wonder if there
>>>>>>> is support for it in recent kernels. According to
>>>>>>> http://marc.info/?l=linux-wireless&m=123178916308198&w=2 (search for
>>>>>>> 8385) there seems to be support but I don't want to start messing 
>>>>>>> around
>>>>>>> with kernels and stuff without being sure.
>>>>>>>        
>>>>>> That driver is for SDIO hardware.  It looks like your FSG-3 has
>>>>>> mini-PCI?  Either way, we don't have a driver merged yet that would
>>>>>> cover your hardware.
>>>>>>      
>>>>> Looks like it's a CB35, which is actually an 88w8335 MiniPCI card.
>>>>> Would be supported by the mwl8k driver ideally.  I've started on trying
>>>>> to add support to mwl8k for the 8335 parts, but we'll need to split the
>>>>> driver so that we can create IO hooks for the different parts.  It'll be
>>>>> a bit, but we'll get there.
>>>>>
>>>>> Dan
>>>>>    
>>>> Very interested in the progress of 8335 support at some point.  My 
>>>> Netgear wg311v3 is sitting on my desk... waiting for some Linux bits to 
>>>> get it running!
>>>>
>>>> I can assist in testing whenever bits become available ( officially or 
>>>> unofficially, hint, hint! :-P )
>>>>
>>>> Thanks for the hard work, and keep them bits a comin'
>>>>
>>>> JD
>>>>
>>> Thanks for the info, I've found something that is said to be a working 
>>> drivers for 'my' card in this package: 
>>> http://www.seagate.com/staticfiles/maxtor/en_us/downloads/MSSII_3.1.2.src.tgz
>>>
>>> The kernel source says it's some kind of 2.6 kernel, grepping for it I 
>>> found the highest number to be 2.6.14 so maybe it is possible to use 
>>> something from it.
>>>
>>> AFAIK it's also GPL.
>> Wow, that is the right driver...  haven't seen a driver for the 8335
>> before, but there it is, and it's GPL too.  Got the firmware too, which
>> I also haven't seen separately.
>>
>> The path forward with this is to port the support for the hardware over
>> to mwl8k since the firmware interface is almost the same.
>>
>> That said, the only reason I chose that as the path forward was that we
>> couldn't make any progress with the standalone driver, and figured that
>> Marvell's driver would actually work where mrv8k didn't.  I still think
>> it makes sense to use the same driver core for both but if that turns
>> out to be too hard, we can just do a mac80211 port for this.
> 
> As a follow-up... the driver source contained in that tarball compiles
> after a few trivial changes to update net80211 and hardware parts to the
> latest kernel.  However, the firmware does not successfully load.  It
> appears that the firmware load procedure for the MSSII driver is a
> one-stage firmware load that probably depends on a minimal bootloader on
> firmware of the card, or something like that.  In any case, it doesn't
> work.
> 
> I spent some time porting over the firmware loading from mrv8k (which is
> known to work), and got as far as successful boot and main firmware
> load, but I'm not having a ton of success getting the card to actually
> boot the main firmware.  More poking required.  If the MSSII driver can
> actually *drive* 8335 cards, then we can use that as a reference for
> hardware/firmware API when adding support for 8335 to mwl8k.
> 
> Dan
> 

Ok, cool, both good and bad news. Is there anything I can do to help out?

(I'm an extremely unexperienced kernel-user, that means I dread 
compiling one myself, but I think that with some help or a nice 
config.gz I will manage. Also I'm really eager to get this working so I 
will take some chances if that is of any help.)

/tsr

