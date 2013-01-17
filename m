Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout3.freenet.de ([195.4.92.93]:47339 "EHLO mout3.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab3AQLn6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2013 06:43:58 -0500
Date: Thu, 17 Jan 2013 12:25:04 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Seth Forshee <seth.forshee@canonical.com>,
	Paul Stewart <pstew@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: Re: [RFC] mac80211: soft scan vs latency
Message-ID: <20130117122504.1bf51f82@dualc.maya.org> (sfid-20130117_124404_116951_831777D9)
In-Reply-To: <20130116140102.GA10746@redhat.com>
References: <20130114145558.GA24250@redhat.com>
	<20130116140102.GA10746@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 16 Jan 2013 15:01:02 +0100
Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> On Mon, Jan 14, 2013 at 03:55:58PM +0100, Stanislaw Gruszka wrote:
> > Except latency, patch perhaps also improve throughput, since we
> > spend more time on-channel while scanning. But I'm not quite sure,
> > since overall scanning time is bigger. I did not test influence of
> > the patch on throughput.
> > 
> > I tested patch by doing:
> > 
> > while true; do iw dev wlan0 scan; sleep 3; done > /dev/null
> 
> I can see slight throughput improvement with patch, measured by scp:
> 
> Upload to periodical scanning machine:
> scp -B Fedora-18-Beta-i686-Live-Desktop.iso stasiu@192.168.1.105:~/
> 
> Unpatched: 3.9MB/s   03:15    
> Patched:   4.3MB/s   02:58

W/o any scan?

> Download from periodical scanning machine:
> scp -B stasiu@192.168.1.105:~/Fedora-18-Beta-i686-Live-Desktop.iso .
> 
> Unpatched: 5.5MB/s   02:17
> Patched:   6.2MB/s   02:02

W/o any scan?


I saw this problem some days ago, too. And: You are right. Using
realtime applications is quite unusable with stock sw-stack. That's one
reason amongst others why I don't use networkmanager at all, but
solely wpa_supplicant and managed dhcpcd via wpa_supplicant logfile
while starting.

But this is not the only point, which breaks realtime applications.
Another one is rekeying (4 way handshake), which is broken when
executed while network load.



Kind regards,
Andreas Hartmann
