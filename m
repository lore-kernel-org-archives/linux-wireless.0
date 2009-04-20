Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:47016 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbZDTJUc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 05:20:32 -0400
Received: by gxk10 with SMTP id 10so344081gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 20 Apr 2009 02:20:31 -0700 (PDT)
Message-ID: <49EC3E5B.8060403@tuffmail.co.uk> (sfid-20090420_112036_234494_DAA3E5BF)
Date: Mon, 20 Apr 2009 10:20:27 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: rfkill rewrite bug
References: <49DCA88E.6060400@tuffmail.co.uk>	 (sfid-20090408_153722_059382_FB44D658) <1239204090.16477.1.camel@johannes.local>	 <49DCDD2E.80705@tuffmail.co.uk>  <49E38BBC.5010708@tuffmail.co.uk>	 (sfid-20090413_205524_915082_56358705) <1239741968.4205.1.camel@johannes.local>	 <49E98C86.2040308@tuffmail.co.uk>	 (sfid-20090418_101208_980691_83127E2F) <1240043283.5792.0.camel@johannes.local>	 <49E9A0C7.8040602@tuffmail.co.uk>	 (sfid-20090418_114338_695917_3CBF9024) <1240057470.4755.7.camel@johannes.local>	 <49EA10F3.3070309@tuffmail.co.uk>	 (sfid-20090418_194244_839181_896F358B) <1240077571.25100.3.camel@johannes.local>	 <49EC3366.7080206@tuffmail.co.uk> (sfid-20090420_103348_397116_B4EBC1A4) <1240217064.28218.0.camel@johannes.local>
In-Reply-To: <1240217064.28218.0.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Mon, 2009-04-20 at 09:33 +0100, Alan Jenkins wrote:
>
>   
>> Ok, revised patch is below. Don't forget the set_sw_state() ->
>> set_global_sw_state() change; I didn't include that.
>>     
>
> Ok, will do. Thanks for the patch, I'll integrate it into mine.
>
>   
>> Note that there other pending changes to the rfkill code in eeepc-laptop.
>>
>> "[PATCH] eee-laptop: Register as a pci-hotplug device"
>> <http://thread.gmane.org/gmane.linux.kernel/791730/focus=38724>
>>
>> "[PATCH] eeepc-laptop: Work around rfkill firmware bug"
>> <http://thread.gmane.org/gmane.linux.acpi.devel/38424>
>>
>> The second is mine; sorry for not warning about it sooner.  So you/we
>> probably need to co-ordinate with the maintainer.  I'd CC linux-acpi,
>> because that's where most platform driver changes are submitted.
>>     
>
> Ok, thanks for the heads up. Do you think this will generate significant
> conflicts?
>   

I'm not quite sure what would be considered significant, but it's not
trivial.  At a high level, I don't think the new behaviours conflict
with the new rfkill semantics :-).  But the firmware bug workaround
can't be resolved completely mechanically.  And the pci-hotplug patch
touches the rfkill error path.
