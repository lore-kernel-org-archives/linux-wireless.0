Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35875 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab0KWXGh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 18:06:37 -0500
Received: by qwb7 with SMTP id 7so116681qwb.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 15:06:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1290500915.3674.1.camel@jlt3.sipsolutions.net>
References: <1289867251-21559-1-git-send-email-javier@cozybit.com>
 <1289946246.3673.12.camel@jlt3.sipsolutions.net> <AANLkTimuW8wTVUW4dH1t+J6jhoEkFHZ7v5t78tXe050O@mail.gmail.com>
 <1289959503.29119.2.camel@jlt3.sipsolutions.net> <AANLkTimFe7uo28u3Sx4rc9uYJms7Ggh=yW9UMDDWgQce@mail.gmail.com>
 <1290500915.3674.1.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Tue, 23 Nov 2010 15:06:16 -0800
Message-ID: <AANLkTikXhNM=LOsX3tdf=7RorGd=GSSLCTpDRDGMLZZE@mail.gmail.com>
Subject: Re: [PATCH] iw: Resolve namespace clash between station plink and
 vlan commands
To: Johannes Berg <johannes@sipsolutions.net>
Cc: nbd@openwrt.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

It works exactly as I hoped it would.  Thanks!
(We only tested the plink_action alias, not the vlan)

Cheers,

Javier

On Tue, Nov 23, 2010 at 12:28 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2010-11-16 at 20:41 -0800, Javier Cardona wrote:
>
>> > Actually, I won't have time today, but it looks like they can be shared
>> > in some way? Maybe by sharing the same callback function or something? I
>> > mean -- it should be possible to do two things on set... not sure now,
>> > I'll take a look later. Maybe you can work with an older iw version
>> > until then?
>>
>> We tried that at first but could not get the usage message right in
>> case of missing parameters.  If you can suggest a solution to this,
>> we'll be happy to implement it.
>
> Try this please?
>
> johannes
>
> diff --git a/info.c b/info.c
> index d842c26..0783701 100644
> --- a/info.c
> +++ b/info.c
> @@ -223,7 +223,7 @@ static int handle_info(struct nl80211_state *state,
>        return 0;
>  }
>  __COMMAND(NULL, info, "info", NULL, NL80211_CMD_GET_WIPHY, 0, 0, CIB_PHY, handle_info,
> -        "Show capabilities for the specified wireless device.");
> +        "Show capabilities for the specified wireless device.", NULL);
>  TOPLEVEL(list, NULL, NL80211_CMD_GET_WIPHY, NLM_F_DUMP, CIB_NONE, handle_info,
>         "List all wireless devices and their capabilities.");
>  TOPLEVEL(phy, NULL, NL80211_CMD_GET_WIPHY, NLM_F_DUMP, CIB_NONE, handle_info, NULL);
> diff --git a/iw.c b/iw.c
> index 562f17b..2593481 100644
> --- a/iw.c
> +++ b/iw.c
> @@ -358,6 +358,12 @@ static int __handle_cmd(struct nl80211_state *state, enum id_input idby,
>                        return 1;
>        }
>
> +       if (cmd->selector) {
> +               cmd = cmd->selector(argc, argv);
> +               if (!cmd)
> +                       return 1;
> +       }
> +
>        if (cmdout)
>                *cmdout = cmd;
>
> diff --git a/iw.h b/iw.h
> index 5eb9083..b0bc489 100644
> --- a/iw.h
> +++ b/iw.h
> @@ -51,12 +51,13 @@ struct cmd {
>                       struct nl_cb *cb,
>                       struct nl_msg *msg,
>                       int argc, char **argv);
> +       const struct cmd *(*selector)(int argc, char **argv);
>        const struct cmd *parent;
>  };
>
>  #define ARRAY_SIZE(ar) (sizeof(ar)/sizeof(ar[0]))
>
> -#define __COMMAND(_section, _symname, _name, _args, _nlcmd, _flags, _hidden, _idby, _handler, _help)\
> +#define __COMMAND(_section, _symname, _name, _args, _nlcmd, _flags, _hidden, _idby, _handler, _help, _sel)\
>        static struct cmd                                               \
>        __cmd ## _ ## _symname ## _ ## _handler ## _ ## _nlcmd ## _ ## _idby ## _ ## _hidden\
>        __attribute__((used)) __attribute__((section("__cmd"))) = {     \
> @@ -69,11 +70,17 @@ struct cmd {
>                .handler = (_handler),                                  \
>                .help = (_help),                                        \
>                .parent = _section,                                     \
> -        }
> +               .selector = (_sel),                                     \
> +       }
> +#define __ACMD(_section, _symname, _name, _args, _nlcmd, _flags, _hidden, _idby, _handler, _help, _sel, _alias)\
> +       __COMMAND(_section, _symname, _name, _args, _nlcmd, _flags, _hidden, _idby, _handler, _help, _sel);\
> +       static const struct cmd *_alias = &__cmd ## _ ## _symname ## _ ## _handler ## _ ## _nlcmd ## _ ## _idby ## _ ## _hidden
>  #define COMMAND(section, name, args, cmd, flags, idby, handler, help)  \
> -       __COMMAND(&(__section ## _ ## section), name, #name, args, cmd, flags, 0, idby, handler, help)
> +       __COMMAND(&(__section ## _ ## section), name, #name, args, cmd, flags, 0, idby, handler, help, NULL)
> +#define COMMAND_ALIAS(section, name, args, cmd, flags, idby, handler, help, selector, alias)\
> +       __ACMD(&(__section ## _ ## section), name, #name, args, cmd, flags, 0, idby, handler, help, selector, alias)
>  #define HIDDEN(section, name, args, cmd, flags, idby, handler)         \
> -       __COMMAND(&(__section ## _ ## section), name, #name, args, cmd, flags, 1, idby, handler, NULL)
> +       __COMMAND(&(__section ## _ ## section), name, #name, args, cmd, flags, 1, idby, handler, NULL, NULL)
>
>  #define TOPLEVEL(_name, _args, _nlcmd, _flags, _idby, _handler, _help) \
>        struct cmd                                                      \
> diff --git a/station.c b/station.c
> index 7639553..bfcc5d1 100644
> --- a/station.c
> +++ b/station.c
> @@ -204,6 +204,21 @@ COMMAND(station, del, "<MAC address>",
>        NL80211_CMD_DEL_STATION, 0, CIB_NETDEV, handle_station_get,
>        "Remove the given station entry (use with caution!)");
>
> +static const struct cmd *station_set_plink;
> +static const struct cmd *station_set_vlan;
> +
> +static const struct cmd *select_station_cmd(int argc, char **argv)
> +{
> +       if (argc < 2)
> +               return NULL;
> +       if (strcmp(argv[1], "plink_action") == 0)
> +               return station_set_plink;
> +       if (strcmp(argv[1], "vlan") == 0)
> +               return station_set_vlan;
> +       return NULL;
> +}
> +
> +
>  static int handle_station_set_plink(struct nl80211_state *state,
>                              struct nl_cb *cb,
>                              struct nl_msg *msg,
> @@ -248,9 +263,10 @@ static int handle_station_set_plink(struct nl80211_state *state,
>  nla_put_failure:
>        return -ENOBUFS;
>  }
> -COMMAND(station, set, "<MAC address> plink_action <open|block>",
> +COMMAND_ALIAS(station, set, "<MAC address> plink_action <open|block>",
>        NL80211_CMD_SET_STATION, 0, CIB_NETDEV, handle_station_set_plink,
> -       "Set mesh peer link action for this station (peer).");
> +       "Set mesh peer link action for this station (peer).",
> +       select_station_cmd, station_set_plink);
>
>  static int handle_station_set_vlan(struct nl80211_state *state,
>                              struct nl_cb *cb,
> @@ -294,9 +310,10 @@ static int handle_station_set_vlan(struct nl80211_state *state,
>  nla_put_failure:
>        return -ENOBUFS;
>  }
> -COMMAND(station, set, "<MAC address> vlan <ifindex>",
> +COMMAND_ALIAS(station, set, "<MAC address> vlan <ifindex>",
>        NL80211_CMD_SET_STATION, 0, CIB_NETDEV, handle_station_set_vlan,
> -       "Set an AP VLAN for this station.");
> +       "Set an AP VLAN for this station.",
> +       select_station_cmd, station_set_vlan);
>
>
>  static int handle_station_dump(struct nl80211_state *state,
>
>
>



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
