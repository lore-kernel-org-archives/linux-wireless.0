Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:34110 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbaAVSc6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 13:32:58 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [RFC 1/5] cfg80211: export minstrel best rate information through get_station()
From: =?iso-8859-1?Q?Thomas_H=FChn?= <thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1390401820.4334.32.camel@jlt4.sipsolutions.net>
Date: Wed, 22 Jan 2014 19:32:55 +0100
Cc: Antonio Quartulli <antonio@meshcoding.com>,
	Antonio Quartulli <antonio@open-mesh.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Message-Id: <7C173B24-D062-49BE-836E-E0889633E955@net.t-labs.tu-berlin.de> (sfid-20140122_193301_423085_8A5EBD6B)
References: <1390302591-3352-1-git-send-email-antonio@meshcoding.com> <1390302591-3352-2-git-send-email-antonio@meshcoding.com> <1390320014.6199.61.camel@jlt4.sipsolutions.net> <52DE9BAA.6020205@open-mesh.com> <1390321084.6199.65.camel@jlt4.sipsolutions.net> <52DEA10F.6090700@meshcoding.com> <52DFD8A5.5090800@meshcoding.com> <1390401820.4334.32.camel@jlt4.sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I do also agree that the expected throughput [=max_throughput(mac_throughput_rate) * success_probability(max_throughput_rate)] is the value of interest.
For my current power control development I just use those minstrel statistics per client, that are provided via debugfs and parse those values that I am interested.
Maybe it is an alternative option for your development of batman is such a way to use those debugfs statistics, where you have all information, expected throughput included. And once your experimentation shows which subset of those stats is sufficient for a better routing performance, you go for a proper api. Or are you already confident about the expected throughput value is the one and only ?

Greetings Thomas

On 22.01.2014, at 15:43, Johannes Berg <johannes@sipsolutions.net> wrote:

> On Wed, 2014-01-22 at 15:41 +0100, Antonio Quartulli wrote:
> 
>> do you think that an API exporting the "expected throughput" would be a
>> acceptable? At that point any RC algorithm can implement it the way it
>> prefers.
> 
> I think that's a better choice, yes.
> 
> johannes
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

