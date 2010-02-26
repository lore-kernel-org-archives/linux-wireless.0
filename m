Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp102.plus.mail.re1.yahoo.com ([69.147.102.65]:46123 "HELO
	smtp102.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934800Ab0BZBV4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 20:21:56 -0500
Message-ID: <4B872231.5020609@yahoo.com>
Date: Fri, 26 Feb 2010 02:21:53 +0100
From: Alban Browaeys <prahal@yahoo.com>
Reply-To: prahal@yahoo.com
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: Ivo van Doorn <ivdoorn@gmail.com>, Pavel Roskin <proski@gnu.org>,
	John Linville <linville@tuxdriver.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 1/2] rt2x00 : hw support txdone implementation.	(without
 fallback change)
References: <4B85FA66.2020503@yahoo.com> <1267120092.25296.31.camel@mj> <4B86D0BD.3000803@yahoo.com> <201002252146.22846.IvDoorn@gmail.com> <20100225205342.GF10960@localhost.localdomain>
In-Reply-To: <20100225205342.GF10960@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25/02/2010 21:53, Josef Bacik wrote:
> On Thu, Feb 25, 2010 at 09:46:22PM +0100, Ivo van Doorn wrote:
>    
>> Hi,
>>
>> Overall this patch has great similarities to something which Josef (CC added)
>> has posted earlier. The patch in question was not merged due to some issues,
>> but he is working on an updated. You might want to synchronize your work
>> with him. :)
>>
>>      
> I was just looking at this patch series, but I couldn't get it to apply at all.
> Alban, does your patch series depend on other patches not in wireless-testing?
> It may have just been the whitespaces or something, cause the context looked
> right, it just wouldn't apply anything.  Anyway I'm happy to work together, or
> I can just send you what I have and I'll be the guinea pig, since this really
> isn't my area of expertise.  Thanks,
>
>    


Well I cannot agree on the replacement from TX_STA_FIFO by DMA DONE 
interrupts
handlers. As the latter prevents from having any success/failure status.
The txdone was borked and could not worked since WirelessCliId was read 
as a queue entry index
and written as an encryption key. What you noticed too though with the 
weird values you got.

Could you try 
http://article.gmane.org/gmane.linux.kernel.wireless.general/47183 
probably and also "pull" from
http://git.prahal.homelinux.net/?p=rt2x00.git;a=shortlog;h=refs/heads/rtt3070v2-next-debug.
It is not a clean set of patches though I am doing my best to get it 
ready at least for to be sent to the ML.

The last commits adds a lot of printk (this is a debug branch) to try to 
decipher a weird issue with long range issues.


Best regards
Alban

