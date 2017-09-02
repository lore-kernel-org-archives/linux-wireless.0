Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46326 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752150AbdIBIa6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Sep 2017 04:30:58 -0400
Date: Sat, 2 Sep 2017 10:30:55 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Nishank aggarwal <nishank.aggarwal89@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: Sequence Number Issue for QoS frames in 3352 SOC
Message-ID: <20170902083055.GB11293@redhat.com> (sfid-20170902_103101_967272_47917D87)
References: <CAGb8t=s+KYFnCxgMbyhGS9trujA+xdAiEwLNVEZyocHSSb-PNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGb8t=s+KYFnCxgMbyhGS9trujA+xdAiEwLNVEZyocHSSb-PNg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 01, 2017 at 04:18:36PM +0530, Nishank aggarwal wrote:
> *This is Nishank Aggarwal having 4 years of Experience in Linux Device
> Driver Development . I would like to discuss one issue i am facing in my
> current project related to WLAN 802.11 e Qos data frame.*
> *We are using 3352 SOC openwrt where i am getting one issue " STA
> re-transmitting the frames with incremented sequence number.
> <https://github.com/VivintInnovationJDM/ges-openwrt/issues/33>"*

This link seems to be wrong.

> *for Qos data frame, I paste some of the examples of sniffer logs captured.*
> 
> 226269	2017-07-04 11
> <callto:226269%202017-07-04%2011>:46:42.358904	3c:4f:2d:6c:a9:e7	Netgear_3d:d5:cd	QoS
> Data, SN=15, FN=0, Flags=.p..TC	15
> 
> 226272	2017-07-04 11
> <callto:226272%202017-07-04%2011>:46:42.358904	3c:4f:2d:6c:a9:e7	Netgear_3d:d5:cd	QoS
> Data, SN=16, FN=0, Flags=.p..R..TC	16	Frame is being
> retransmitted226279	2017-07-04 11
> <callto:226279%202017-07-04%2011>:46:42.366403	3c:4f:2d:6c:a9:e7	Netgear_3d:d5:cd	QoS
> Data, SN=17, FN=0, Flags=.p..R..TC	17	Frame is being retransmitted
> 
> *I know QoS data  frames are generated in mac layer but i am not aware
> about where re-transmission of  QoS data  frames is taken care. I would
> like to know how the re-transmission frame are generated for the QoS data
> in the 3352 SOC. *

Data frames are retransmitted by the hardware. If sequence numbers
are incorrectly increased, it can be hardware or firmware bug,
but is also possible that some HW register is not correctly
programmed by the driver.

Stanislaw
