Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:33534 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaI3RQf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 13:16:35 -0400
Message-ID: <542AE571.40007@candelatech.com> (sfid-20140930_191638_081438_19E44510)
Date: Tue, 30 Sep 2014 10:16:33 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Marcel Holtmann <marcel@holtmann.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Anyone working on making iw able to specify MAC address at station
 creation time?
References: <5408A6BD.6090304@candelatech.com>  (sfid-20140904_195201_728073_99DA3C67) <1409898836.1940.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1409898836.1940.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/04/2014 11:33 PM, Johannes Berg wrote:
> On Thu, 2014-09-04 at 10:51 -0700, Ben Greear wrote:
>> I'm having issues with udev renaming newly created stations when I have
>> udev rules for wlanX, when wlanX is not already existing.
>>
>> I think specifying MAC on station creation time would solve my problems,
>> but haven't looked closely yet.
>>
>> My version of 'iw' doesn't support setting the MAC on creation, from
>> what I can tel.
>>
>> Curious if anyone else is working on this?
> 
> I think Marcel mentioned wanting this before. There's even an attribute
> in nl80211 already, but it can only be used for P2P_DEVICE I believe, so
> a feature flag or so would be needed to be able to know whether or not
> this would be expected to take any effect (kernels before those future
> changes would ignore the attribute for non-P2P-DEVICE I believe)
> 
> Haven't looked at the code right now, this is all I know.

In the iw code, it seems that the arguments: mesh_id, 4addr, flags
cannot be used at the same time?

I want to add an option pass an optional mac-address as
well.  It would be easier if I processed args in a loop
and removed the exclusivity on those 3 above, but if they
do need to remain exclusive, then I can do that too:


static int handle_interface_add(struct nl80211_state *state,
				struct nl_cb *cb,
				struct nl_msg *msg,
				int argc, char **argv,
				enum id_input id)
{
	char *name;
	char *mesh_id = NULL;
	enum nl80211_iftype type;
	int tpset;

	if (argc < 1)
		return 1;

	name = argv[0];
	argc--;
	argv++;

	tpset = get_if_type(&argc, &argv, &type, true);
	if (tpset)
		return tpset;

	if (argc) {
		if (strcmp(argv[0], "mesh_id") == 0) {
			argc--;
			argv++;

			if (!argc)
				return 1;
			mesh_id = argv[0];
			argc--;
			argv++;
		} else if (strcmp(argv[0], "4addr") == 0) {
			argc--;
			argv++;
			if (parse_4addr_flag(argv[0], msg)) {
				fprintf(stderr, "4addr error\n");
				return 2;
			}
			argc--;
			argv++;
		} else if (strcmp(argv[0], "flags") == 0) {
			argc--;
			argv++;
			if (parse_mntr_flags(&argc, &argv, msg)) {
				fprintf(stderr, "flags error\n");
				return 2;
			}
		} else {
			return 1;
		}
	}

	if (argc)
		return 1;


Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

