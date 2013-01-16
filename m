Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab3APODC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 09:03:02 -0500
Date: Wed, 16 Jan 2013 15:01:02 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>,
	Paul Stewart <pstew@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: Re: [RFC] mac80211: soft scan vs latency
Message-ID: <20130116140102.GA10746@redhat.com> (sfid-20130116_150306_760516_BB02AFFD)
References: <20130114145558.GA24250@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130114145558.GA24250@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 14, 2013 at 03:55:58PM +0100, Stanislaw Gruszka wrote:
> Except latency, patch perhaps also improve throughput, since we spend
> more time on-channel while scanning. But I'm not quite sure, since
> overall scanning time is bigger. I did not test influence of the patch
> on throughput.
> 
> I tested patch by doing:
> 
> while true; do iw dev wlan0 scan; sleep 3; done > /dev/null

I can see slight throughput improvement with patch, measured by scp:

Upload to periodical scanning machine:
scp -B Fedora-18-Beta-i686-Live-Desktop.iso stasiu@192.168.1.105:~/

Unpatched: 3.9MB/s   03:15    
Patched:   4.3MB/s   02:58

Download from periodical scanning machine:
scp -B stasiu@192.168.1.105:~/Fedora-18-Beta-i686-Live-Desktop.iso .

Unpatched: 5.5MB/s   02:17
Patched:   6.2MB/s   02:02

Stanislaw
