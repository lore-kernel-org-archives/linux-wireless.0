Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:45408 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759559Ab3ECPmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 May 2013 11:42:07 -0400
Received: by mail-ie0-f169.google.com with SMTP id u16so625562iet.14
        for <linux-wireless@vger.kernel.org>; Fri, 03 May 2013 08:42:07 -0700 (PDT)
Date: Fri, 3 May 2013 11:41:02 -0400
From: Bob Copeland <me@bobcopeland.com>
To: devel@lists.open80211s.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wirelss <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 00/12] MBSS sharing across multiple interfaces
Message-ID: <20130503154102.GB1438@localhost> (sfid-20130503_174212_650865_49478675)
References: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
 <BD54DDEB2546894FAB0731EA7B0EDF8D07C5C070@RockMX01.rock.corp>
 <20130503143509.GA1438@localhost>
 <CAEFj986Avr_C5Hm4uRs0oP2ZRa-jnn6eRCJH71jkehcCuQ7iGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAEFj986Avr_C5Hm4uRs0oP2ZRa-jnn6eRCJH71jkehcCuQ7iGQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 03, 2013 at 11:01:48PM +0800, Yeoh Chun-Yeow wrote:
> Hi, Bob
> 
> If we have two mesh interfaces which MBSS sharing is turned on and one
> Ethernet interface in the same host, can we use the brctl to add the mesh
> interfaces and Ethernet interface together, like the following?
> 
> brctl add br-lan mesh0
> brctl add br-lan mesh1
> brctl add br-lan eth0

So in the patch, the frames are already forwarded between the
mesh interfaces, so we've at least tested the case like this:

mesh0/mesh1 shared
brctl addif br-lan mesh1
brctl addif br-lan eth0

Then frames destined for mesh1/eth0 that arrive at mesh0 will be
forwarded to the other devices and vice-versa.  I imagine some
frame duplication would happen if both mesh devices were in the
bridge, but I haven't tried.

-- 
Bob Copeland %% www.bobcopeland.com
