Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756710Ab3AQPSh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2013 10:18:37 -0500
Date: Thu, 17 Jan 2013 16:18:27 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: linux-wireless@vger.kernel.org,
	Seth Forshee <seth.forshee@canonical.com>,
	Paul Stewart <pstew@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: Re: [RFC] mac80211: soft scan vs latency
Message-ID: <20130117151826.GA2341@redhat.com> (sfid-20130117_161847_745086_AF7FCD1E)
References: <20130114145558.GA24250@redhat.com>
 <20130116140102.GA10746@redhat.com>
 <20130117122504.1bf51f82@dualc.maya.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130117122504.1bf51f82@dualc.maya.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 17, 2013 at 12:25:04PM +0100, Andreas Hartmann wrote:
> On Wed, 16 Jan 2013 15:01:02 +0100
> Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> 
> > On Mon, Jan 14, 2013 at 03:55:58PM +0100, Stanislaw Gruszka wrote:
> > > Except latency, patch perhaps also improve throughput, since we
> > > spend more time on-channel while scanning. But I'm not quite sure,
> > > since overall scanning time is bigger. I did not test influence of
> > > the patch on throughput.
> > > 
> > > I tested patch by doing:
> > > 
> > > while true; do iw dev wlan0 scan; sleep 3; done > /dev/null
> > 
> > I can see slight throughput improvement with patch, measured by scp:
> > 
> > Upload to periodical scanning machine:
> > scp -B Fedora-18-Beta-i686-Live-Desktop.iso stasiu@192.168.1.105:~/
> > 
> > Unpatched: 3.9MB/s   03:15    
> > Patched:   4.3MB/s   02:58
> 
> W/o any scan?
> 
> > Download from periodical scanning machine:
> > scp -B stasiu@192.168.1.105:~/Fedora-18-Beta-i686-Live-Desktop.iso .
> > 
> > Unpatched: 5.5MB/s   02:17
> > Patched:   6.2MB/s   02:02
> 
> W/o any scan?

On target machine I performed periodical scan every 3 second i.e.
run command: "while true; do iw dev wlan0 scan; sleep 3; done" .
Source machine was connected to AP by wire.

Stanislaw 

