Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:37256 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbYEPPv4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 11:51:56 -0400
Received: by wf-out-1314.google.com with SMTP id 27so192071wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 16 May 2008 08:51:53 -0700 (PDT)
Message-ID: <69e28c910805160851v7be6ccd0qc5f8538748941e80@mail.gmail.com> (sfid-20080516_175159_560646_B40A5FF8)
Date: Fri, 16 May 2008 17:51:53 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH stable] libertas: Extend CMD_MESH_CONFIG to get and set persistent mesh default params.
Cc: "David Woodhouse" <dwmw2@infradead.org>,
	"Brian Cavagnolo" <brian@cozybit.com>, devel@laptop.org,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Andres Salomon" <dilinger@queued.net>,
	"Javier Cardona" <javier@cozybit.com>,
	"Ricardo Carrano" <carrano@ricardocarrano.com>
In-Reply-To: <1210949448.6381.13.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <482c8eb8.0b97600a.08e2.ffff8ee3@mx.google.com>
	 <1210946949.3008.16.camel@pmac.infradead.org>
	 <1210949448.6381.13.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 16, 2008 at 4:50 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2008-05-16 at 15:09 +0100, David Woodhouse wrote:
>> On Thu, 2008-05-15 at 11:01 -0700, Brian Cavagnolo wrote:
>> > This patch is based on a patch from Shailendra Govardhan.  It introduces
>> > several new iwprivs: {get,set}_bootflag {get,set}_boottime {get,set}_def_chan
>> > {get,set}_def_protid {get,set}_def_metid {get,set}_def_meshcap
>> > {get,set}_def_meshid.  These commands are only supported on Marvell hardware
>> > that implements persistent defaults, such as the OLPC Active Antenna.
>> > Accordingly, this patch may not be suitable for upstream merging.
>
>> But this is the _one_ thing which might actually be OK to do with a
>> private ioctl, since it's very hardware-specific. Unlike like all the
>> mesh-mangling stuff where we really ought to be compatible with o11s.
>>
>> So maybe, just maybe, we _can_ do this with iwpriv and push that
>> upstream.
>
> Maybe we do, after all, need an iwpriv equivalent in cfg80211/nl80211 so
> that we can kill wext at some point.
>
> Or maybe this should be in sysfs or so?
>
> johannes
>

Or maybe in configfs? That's a better place for configuration options.
(BTW rt2x00 uses debugfs as an iwpriv replacement, so that's another
possibility.)

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
