Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62434 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847Ab2LHDRX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 22:17:23 -0500
Received: by mail-wi0-f174.google.com with SMTP id hm9so67819wib.1
        for <linux-wireless@vger.kernel.org>; Fri, 07 Dec 2012 19:17:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1212031842350.27546@icf.org.ru>
References: <BD54DDEB2546894FAB0731EA7B0EDF8D07C1256F@RockMX01.rock.corp> <alpine.DEB.2.02.1212031842350.27546@icf.org.ru>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Fri, 7 Dec 2012 19:17:02 -0800
Message-ID: <CAG6hwVM3GFe-v7fONDR_2wuggT+z_ZhDQN-pH7BA1gyxLZzDQQ@mail.gmail.com> (sfid-20121208_041730_230983_0D68D6B5)
Subject: Re: help: 802.11s bad performance with 802.11n enabled
To: Georgiewskiy Yuriy <bottleman@icf.org.ru>
Cc: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	open11s <devel@lists.open80211s.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Chaoxing and Georgiewsky,

On Mon, Dec 3, 2012 at 6:45 AM, Georgiewskiy Yuriy <bottleman@icf.org.ru> wrote:
> On 2012-12-03 14:37 -0000, Chaoxing Lin wrote linux-wireless@vger.kernel.org:
>
> CL>After a lot of experiments, here are various problems observed.
> CL>
> CL>1. The "Fail to stop Tx DMA" related issue plays a role. But not the major part. It accounts for about 3% of packet loss in my testbed.
> CL>Is anyone looking at this issue? This issue is now very easy to recreate.
>
> In my case it much more than 3%.

With wireless-testing HEAD (671c924) I made the following observations
with 3 nodes in a mesh using ch. 149 HT20 on AR9280.

1. ping -i0.1 does not cause aggregation to take place, and losses are 0%
2. a UDP iperf test with two nodes generating traffic shows losses
around 1%. We can observe aggregation taking place in this case.

Can either of you guys reproduce this with the latest
wireless-testing? Also please CC devel@lists.open80211s.org on any
mesh bugs in the future.

Thanks!
Thomas
