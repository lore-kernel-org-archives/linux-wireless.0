Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534Ab1FFLgn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 07:36:43 -0400
Date: Mon, 6 Jun 2011 13:36:12 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [iwl4965] Microcode SW error detected
Message-ID: <20110606113611.GB2530@redhat.com> (sfid-20110606_133646_706094_DC0D314F)
References: <1306151106.2066.60.camel@x61.thuisdomein>
 <20110524070941.GA2189@redhat.com>
 <1306255853.12267.14.camel@x61.thuisdomein>
 <20110525131130.GA3260@redhat.com>
 <1306330313.2119.4.camel@x61.thuisdomein>
 <20110531133736.GA2935@redhat.com>
 <1307350722.10094.29.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1307350722.10094.29.camel@x61.thuisdomein>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 06, 2011 at 10:58:42AM +0200, Paul Bolle wrote:
> On Tue, 2011-05-31 at 15:37 +0200, Stanislaw Gruszka wrote:
> > My all attempts of reproduce the problem was unsuccessful. Please
> > send me (off list since this could be quite big) dmesg output from 
> > loading module to first microcode error, when using verbose debug eg:
> > 
> > $ modprobe -r iwl4965
> > $ modprobe iwl4965 debug=0x47ffffff  
> > 
> > Note: driver have to be compiled with CONFIG_IWLWIFI_LEGACY_DEBUG.
> > Also dmesg circular buffer can be too small to contain all requested
> > messages. In such case, you will have to configure syslog like described
> > here:
> > https://bugzilla.kernel.org/show_bug.cgi?id=35932#c2
> 
> 0) I have not yet done that, but I do hope to do it shortly.
> 
> 1) This Microcode SW error pops up only every now and then, so I'm
> afraid I might find myself logging debug messages for quite some time.

Hmm, perhaps there is some way to reproduce a error?

> What is the average volume of those messages? If it's no more than, say,
> 10 MB/min I can still run in verbose debug mode for hours on end without
> worrying about running out of disk space.  

I don't know how fast verbose logging will eat disk space, perhaps
you can check that? :-) Maybe logger could be configured to do not
log date, hostname and component, that would decrease size of logs
vastly. If not, less verbose logging could be used, let say
debug=0x00375fff, that will miss some information, but maybe would be
enough to figure out where the bug is.

Thanks
Stanislaw
