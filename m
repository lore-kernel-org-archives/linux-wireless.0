Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58349 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab0KMM4T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Nov 2010 07:56:19 -0500
Received: by qyk4 with SMTP id 4so476479qyk.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Nov 2010 04:56:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101110194039.GE2714@tuxdriver.com>
References: <201011042037.00178.IvDoorn@gmail.com>
	<201011051044.37167.helmut.schaa@googlemail.com>
	<AANLkTinDwi_77iVS-bOTSX_4zs76nyttoEsdfpV0_F2g@mail.gmail.com>
	<201011051056.03700.helmut.schaa@googlemail.com>
	<AANLkTi=2PBV2nQTqnMwm_hJcq6=jb_E=81mhic9DbqpG@mail.gmail.com>
	<20101110194039.GE2714@tuxdriver.com>
Date: Sat, 13 Nov 2010 13:56:18 +0100
Message-ID: <AANLkTini--JJXSU=6S3So8O2VnGDLH=BBr-H707PMc+N@mail.gmail.com>
Subject: Re: [PATCH 03/13] rt2x00: Wait up to one second on rt2800 for WPDMA
 to be ready
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 10, 2010 at 8:40 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Fri, Nov 05, 2010 at 11:07:22AM +0100, Ivo Van Doorn wrote:
>> Hi,
>>
>> >> On Fri, Nov 5, 2010 at 10:44 AM, Helmut Schaa
>> >> <helmut.schaa@googlemail.com> wrote:
>> >> > Hi,
>> >> >
>> >> > Am Donnerstag 04 November 2010 schrieb Ivo van Doorn:
>> >> >> From: Helmut Schaa <helmut.schaa@googlemail.com>
>> >> >>
>> >> >> At least some devices need such a long time to inititalize WPDMA. This
>> >> >> only increases the maximum wait time and shouldn't affect devices that
>> >> >> have been working before.
>> >> >>
>> >> >> Reported-by: Joshua Smith <jesmith@kaon.com>
>> >> >> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
>> >> >> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
>> >> >> ---
>> >> >
>> >> > Ivo, the patch context looks different then in the version I've send to you.
>> >> >
>> >> > The
>> >> >        for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
>> >> > should be
>> >> >        for (i = 0; i < 100; i++) {
>> >> >
>> >> > Otherwise we don't wait up to one second as in the comment but just 50ms :P
>> >> >
>> >> > However, that change was part of a previous patch that was already merged into
>> >> > the rt2x00 git tree. Seems like that change got lost during the merge ...
>> >>
>> >> I'll try to find the patch which changed the REGISTER_BUSY_COUNT behavior.
>> >
>> > I'm not sure but I guess I haven't sent that one as separate [PATCH] but it
>> > was inlined in the mail traffic with Joshua ("Question about starting up an
>> > AP").
>>
>> Ah ok, that explains why I missed it. I'll dig it up, and send it to
>> wireless-testing
>> as soon as possible (John, do you want it as separate patch, or should
>> it be merged
>> into this patch?).
>
> Separate patch, please (if you haven't already sent it).

Ok, patch will follow today.

ivo
