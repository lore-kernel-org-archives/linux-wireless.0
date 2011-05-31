Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab1EaNiO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 09:38:14 -0400
Date: Tue, 31 May 2011 15:37:39 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [iwl4965] Microcode SW error detected
Message-ID: <20110531133736.GA2935@redhat.com> (sfid-20110531_153817_026759_096486D0)
References: <1306151106.2066.60.camel@x61.thuisdomein>
 <20110524070941.GA2189@redhat.com>
 <1306255853.12267.14.camel@x61.thuisdomein>
 <20110525131130.GA3260@redhat.com>
 <1306330313.2119.4.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1306330313.2119.4.camel@x61.thuisdomein>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 25, 2011 at 03:31:53PM +0200, Paul Bolle wrote:
> On Wed, 2011-05-25 at 15:11 +0200, Stanislaw Gruszka wrote:
> 
> > What channel do you use?
> 11, 2.462 GHz (according to my basestation)
> 
> > Is network 11n or 11g or mixed ?
> Network is mixed 11b and 11g (according to my basestation)
> 
> > WEP is 40 bits or other?
> 128 bits, 26 hex digits (again, according to my basestation)

My all attempts of reproduce the problem was unsuccessful. Please
send me (off list since this could be quite big) dmesg output from 
loading module to first microcode error, when using verbose debug eg:

$ modprobe -r iwl4965
$ modprobe iwl4965 debug=0x47ffffff  

Note: driver have to be compiled with CONFIG_IWLWIFI_LEGACY_DEBUG.
Also dmesg circular buffer can be too small to contain all requested
messages. In such case, you will have to configure syslog like described
here:
https://bugzilla.kernel.org/show_bug.cgi?id=35932#c2

Stanislaw
