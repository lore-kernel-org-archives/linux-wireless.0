Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f180.google.com ([209.85.210.180]:35423 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933859Ab3ECOgP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 May 2013 10:36:15 -0400
Received: by mail-ia0-f180.google.com with SMTP id 21so1110610iay.39
        for <linux-wireless@vger.kernel.org>; Fri, 03 May 2013 07:36:14 -0700 (PDT)
Date: Fri, 3 May 2013 10:35:09 -0400
From: Bob Copeland <me@bobcopeland.com>
To: devel@lists.open80211s.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wirelss <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 00/12] MBSS sharing across multiple interfaces
Message-ID: <20130503143509.GA1438@localhost> (sfid-20130503_163922_076629_EEF190F1)
References: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
 <BD54DDEB2546894FAB0731EA7B0EDF8D07C5C070@RockMX01.rock.corp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BD54DDEB2546894FAB0731EA7B0EDF8D07C5C070@RockMX01.rock.corp>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 03, 2013 at 01:25:34PM +0000, Chaoxing Lin wrote:
> I have some questions and comments.
> 
> Question 1
> 
> The typical use case of multiple interfaces on this same host is to do
> RF segregation in order to improve overall network performance. e.g.
> divide a original mesh of 16 radios into 2 meshes of 8 radios each.
> This multi-radio host bridges these two small meshes which are on
> different channels. I can't see why user would put multiple radios of
> the same host on the same channel. They would just interfere with each
> other very badly. 

Yes, you want to use different channels.  Also, you need to have good
spacing between the radios, because even on different channels, closely
located radios will interfere.  We found that putting one in 2.4 ghz
band and one in 5 ghz band worked without resorting to directional
antennas or the like.

> In MPP where there are multiple mesh interfaces, AP interface and/or Ethernet interface, how does this "MBSS sharing" work? 
> 	a. add both mesh interface in 802.1d bridge, or
> 	b. add either interface in bridge, or
> 	c. sharing can't be used

You should be able to add either interface in the bridge.

-- 
Bob Copeland %% www.bobcopeland.com
