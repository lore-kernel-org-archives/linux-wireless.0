Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:50903 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab3JTKjt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Oct 2013 06:39:49 -0400
Received: by mail-la0-f45.google.com with SMTP id hp15so69686lab.32
        for <linux-wireless@vger.kernel.org>; Sun, 20 Oct 2013 03:39:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <D19FD2B13A40CD4B8DA64DB9B8F112E9218DAF6F@nasanexd01a.na.qualcomm.com>
References: <1381985833-31312-1-git-send-email-rajeshc@qca.qualcomm.com>
 <1382020835.14410.16.camel@jlt4.sipsolutions.net> <D19FD2B13A40CD4B8DA64DB9B8F112E9218DAD14@nasanexd01a.na.qualcomm.com>
 <1382035171.22901.13.camel@dcbw.foobar.com> <D19FD2B13A40CD4B8DA64DB9B8F112E9218DAF6F@nasanexd01a.na.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Sun, 20 Oct 2013 12:39:27 +0200
Message-ID: <CAB=NE6UkKuSzH4x2SjkE0pRTVCVa3k7g=_ZeU_JE+t2OovRoEg@mail.gmail.com> (sfid-20131020_124003_283683_5DAA8260)
Subject: Re: [PATCH] cfg80211/nl80211: Add support to report unsafe frequency ranges(s)
To: "Chauhan, Rajesh" <rajeshc@qca.qualcomm.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Malinen, Jouni" <jouni@qca.qualcomm.com>,
	"Bahini, Henri" <hbahini@qca.qualcomm.com>,
	"Chang, Leo" <schang@qca.qualcomm.com>,
	"Luo, Xun" <xunl@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 17, 2013 at 9:51 PM, Chauhan, Rajesh
<rajeshc@qca.qualcomm.com> wrote:
> Hi Dan,
>
> Thanks for your comments.
>
> Current patch is to report event asynchronously and that would be needed even if we have your suggested interface of client collecting that information upfront, which seems like you also kind of agree, because RF environment may change later and generating an event at that time with frequency details would help. So your suggested approach of "mechanism for the client to get this information" in itself seems like a candidate for a separate patch.

The infrastructure for this sort of thing that me, Inaky and Marcel
had proposed in 2007 is the Frequency Broker:

http://wireless.kernel.org/en/developers/FrequencyBroker

> On the race condition which you described - thanks!, but it is something which implementation of driver would need to take care. Similarly, user space can have implementation to cache information on receipt of the event to use it later.

This patch is vague. Once we set something as API we have to live with
it, I am not comfortable with this patch having enough information for
proper usage by different drivers for the same purpose or intent. The
only real positive argument that could be used here is where something
like Android might have already embraced some similar API but are we
going to always just enable API on Linux just because Android did it
without thinking about proper long term architecture? I don't think
so.

 Luis
