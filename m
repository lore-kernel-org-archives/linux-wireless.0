Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.irobot.com ([206.83.81.187]:33422 "EHLO smtp1.irobot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbZKPR54 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 12:57:56 -0500
Message-ID: <4B0192A6.9050808@irobot.com>
Date: Mon, 16 Nov 2009 09:57:58 -0800
From: Adam Wozniak <awozniak@irobot.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	Derek Smithies <derek@indranet.co.nz>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org
Subject: Re: compat-wireless and minstrel
References: <4AF0D54D.4090303@irobot.com>	 <alpine.DEB.2.00.0911111508391.6214@kauri.acheron.indranet.co.nz>	 <4AFC655A.5020706@irobot.com> <200911122103.27455.chunkeey@googlemail.com>	 <4AFC8E4F.5090307@irobot.com>  <4AFC8F0D.5020700@irobot.com>	 <1258097352.3899.75.camel@johannes.local>  <4AFDDF19.8060202@irobot.com>	 <1258191039.6167.40.camel@johannes.local>  <4B018B26.2070008@irobot.com> <1258392453.32159.28.camel@johannes.local>
In-Reply-To: <1258392453.32159.28.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This assumption seems too stoichastic.  Reading 802.11-2007 section 
11.1.2.2, it doesn't seem that we're guaranteed to always receive 
beacons from all stations.  Stations will cancel their pending beacon 
transmission if they receive a beacon before their random delay times 
out.  In the extreme case where the number of stations is very large, it 
seems possible that you may never hear beacons for some stations.

Johannes Berg wrote:
> On Mon, 2009-11-16 at 09:25 -0800, Adam Wozniak wrote:
>   
>> If we have only three stations in an ad-hoc network, where all three can 
>> hear the other two, only one of them should be beaconing, correct?  
>>     
>
> No, if they all behave correctly beaconing will be distributed.
>
> johannes
>   

