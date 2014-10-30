Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40181 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759855AbaJ3TkZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2014 15:40:25 -0400
Date: Thu, 30 Oct 2014 12:39:14 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH 0/3] debugfs: adding helper for single seq_file
Message-ID: <20141030193914.GA28346@kroah.com> (sfid-20141030_204029_021966_5C41C21A)
References: <1414498752-9746-1-git-send-email-arend@broadcom.com>
 <20141030191922.GA3768@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141030191922.GA3768@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 30, 2014 at 03:19:22PM -0400, John W. Linville wrote:
> On Tue, Oct 28, 2014 at 01:19:09PM +0100, Arend van Spriel wrote:
> > The first patch was already posted earlier:
> > 
> > Message-ID: <1413043315-22332-1-git-send-email-arend@broadcom.com>
> > 
> > This series include changes in driver code to investigate potential
> > code savings. As example used the ath9k driver as it has a fair
> > amount of debugfs files. In this series it changes 7 debugfs entries
> > to use seq_file and the helper function. Below the output of the
> > size utility:
> > 
> >    text	   data	    bss	    dec	    hex	filename
> >  115968	   1225	     28	 117221	  1c9e5	original/ath9k.o
> >  113224	   1225	     28	 114477	  1bf2d	seq_file/ath9k.o
> >  111024	   1225	     28	 112277	  1b695	helper/ath9k.o
> > 
> > This series is for 3.19 kernel and applies to the driver-core-next
> > branch of the driver-core repository. If needed the ath9k patches
> > may be dropped for now and I will resubmit them to wireless-next
> > once the debugfs patch has made it into linux-next.
> > 
> > Arend van Spriel (3):
> >   debugfs: add helper function to create device related seq_file
> >   ath: use seq_file api for ath9k debugfs files
> >   ath: ath9k: use debugfs_create_devm_seqfile() helper for seq_file
> >     entries
> 
> Greg,
> 
> If you are happy with the debugfs change then feel free to merge the
> wireless patches along with it.

Ok, will do, can I get your Ack for them?

thanks,

greg k-h
