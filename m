Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55768 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab1ITS4C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 14:56:02 -0400
Received: by yxl31 with SMTP id 31so580662yxl.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2011 11:56:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E78D990.3090601@openwrt.org>
References: <35635039ce7d4a79dc62b19d51ccf0d5d4838112.1316297595.git.an.alexsimon@googlemail.com>
 <loom.20110918T004437-426@post.gmane.org> <1316437459.5995.29.camel@jlt3.sipsolutions.net>
 <36569806.Rgjanm0GiI@alex-1> <1316521312.3953.27.camel@jlt3.sipsolutions.net>
 <CAB=NE6VDSTAKK0pmyBOz6hw1pbxo7U6dxbrvg_F-y6CDB0paKw@mail.gmail.com> <4E78D990.3090601@openwrt.org>
From: Javier Cardona <javier@cozybit.com>
Date: Tue, 20 Sep 2011 11:55:41 -0700
Message-ID: <CAPjQAd_KtVnr5RvGMzPOVsVhKVw4F6PKOb4tUahFMrRR_jBu3w@mail.gmail.com> (sfid-20110920_205606_841375_B4EF4655)
Subject: Re: [PATCH v3 3/3] mac80211: Add HT operation modes for IBSS
To: Felix Fietkau <nbd@openwrt.org>
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Alexander Simon <an.alexsimon@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 20, 2011 at 11:21 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>>>  I don't really know. As I said, I think I'd be happy with an
>>>  implementation that maybe doesn't fully implement everything as long as
>>>  it considers the trade-offs.
>>
>> The same questions come up with HT support and 802.11s, as per Javier
>> this is not really well spelled out in the spec. My recommendation is
>> to just support for now the most simple case and let us not entangle
>> ourselves with the complexities of handling trying to merge different
>> setups. So only enable peering up for adhoc or mesh if and only if the
>> observed IE matches our own supported HT caps or target configuration.
>> If a legacy STA tries to peer up with an HT IBSS, this would simply be
>> rejected. We can leave off handling the change in configuration later
>> for userspace, but do not see this as being a requirement for
>> supporting HT for IBSS or Mesh. The simpler the better, so long as we
>> simply respect the spec.
>
> I disagree. That'll make it useless for real deployments, which are often a
> mix of HT and non-HT devices.

For mesh, my initial thought was to allow mismatched peerings
according to the following rules:

 1. Peering is allowed between non-HT STAs as well as between HT and
non-HT STAs.  No HT checks in that case.
 2. If both peer candidates support HT, only allow peering if they
advertise the same BSSBasicMCSSet in their HT Operation IE.  This
ensures that a basic link can be established between these stations.
 3. Don't use the HT info for anything else: if there are poorly
matched HT links, let the path selection algorithm try and find better
ones (if there are any).

I believe the above is compliant with 802.11s.

Cheers,

Javier
